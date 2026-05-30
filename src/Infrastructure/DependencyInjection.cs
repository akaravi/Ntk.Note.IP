using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Domain.Constants;
using Ntk.Note.IP.Infrastructure.Dns;
using Ntk.Note.IP.Infrastructure.Email;
using Ntk.Note.IP.Infrastructure.DnsResolution;
using Ntk.Note.IP.Infrastructure.Blacklist;
using Ntk.Note.IP.Infrastructure.BackgroundJobs;
using Ntk.Note.IP.Infrastructure.Caching;
using Ntk.Note.IP.Infrastructure.GeoIp;
using Ntk.Note.IP.Infrastructure.IpLookup;
using Ntk.Note.IP.Infrastructure.Maps;
using Ntk.Note.IP.Shared;
using Hangfire;
using Hangfire.MemoryStorage;
using Hangfire.PostgreSql;
using Hangfire.SqlServer;
using Microsoft.Extensions.Caching.Distributed;
using HealthChecks.Redis;
using Ntk.Note.IP.Infrastructure.NetworkTools;
using Ntk.Note.IP.Infrastructure.Push;
using Ntk.Note.IP.Infrastructure.Whois;
using Ntk.Note.IP.Infrastructure.Data;
using Ntk.Note.IP.Infrastructure.Data.Interceptors;
using Ntk.Note.IP.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace Microsoft.Extensions.DependencyInjection;

public static class DependencyInjection
{
    public static void AddInfrastructureServices(this IHostApplicationBuilder builder)
    {
        var connectionString = builder.Configuration.GetConnectionString(Services.Database);
        Guard.Against.Null(connectionString, message: $"Connection string '{Services.Database}' not found.");

        builder.Services.AddScoped<ISaveChangesInterceptor, AuditableEntityInterceptor>();
        builder.Services.AddScoped<ISaveChangesInterceptor, DispatchDomainEventsInterceptor>();

        builder.Services.Configure<DatabaseOptions>(builder.Configuration.GetSection(DatabaseOptions.SectionName));
        var databaseProvider = builder.Configuration.GetValue<string>($"{DatabaseOptions.SectionName}:Provider") ?? "Sqlite";

        var usePostgreSql = DatabaseProviderConfiguration.IsPostgreSql(databaseProvider);
        var useSqlServer = DatabaseProviderConfiguration.IsSqlServer(databaseProvider);

        builder.Services.AddDbContext<ApplicationDbContext>((sp, options) =>
            DatabaseProviderConfiguration.ConfigureDbContext(options, databaseProvider, connectionString, sp));

        var healthChecks = builder.Services.AddHealthChecks()
            .AddDbContextCheck<ApplicationDbContext>(tags: ["ready"]);

        var redisConnection = builder.Configuration.GetConnectionString(Services.Redis);
        if (!string.IsNullOrWhiteSpace(redisConnection))
        {
            var instanceName = builder.Configuration.GetValue<string>($"{CacheOptions.SectionName}:RedisInstanceName") ?? "ipnote:";
            builder.Services.AddStackExchangeRedisCache(options =>
            {
                options.Configuration = redisConnection;
                options.InstanceName = instanceName;
            });

            healthChecks.AddRedis(redisConnection, name: "redis", tags: ["ready"]);
        }

        builder.Services.AddScoped<IApplicationDbContext>(provider => provider.GetRequiredService<ApplicationDbContext>());
        builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();

        builder.Services.AddScoped<ApplicationDbContextInitialiser>();

        builder.Services.AddIpNoteAuthentication(builder.Configuration);

        builder.Services.Configure<SiteOptions>(builder.Configuration.GetSection(SiteOptions.SectionName));
        builder.Services.Configure<SmtpOptions>(builder.Configuration.GetSection(SmtpOptions.SectionName));
        builder.Services.AddTransient<IEmailSender, SmtpEmailSender>();

        builder.Services.AddAuthorizationBuilder()
            .AddPolicy(Policies.RequireAdministrator, policy => policy.RequireRole(Roles.Administrator));

        builder.Services
            .AddIdentityCore<ApplicationUser>()
            .AddRoles<IdentityRole>()
            .AddEntityFrameworkStores<ApplicationDbContext>()
            .AddSignInManager()
            .AddDefaultTokenProviders()
            .AddApiEndpoints();

        builder.Services.AddSingleton(TimeProvider.System);
        builder.Services.AddTransient<IIdentityService, IdentityService>();
        builder.Services.AddTransient<IAdminUserService, AdminUserService>();
        builder.Services.AddTransient<IAdminRoleService, AdminRoleService>();

        builder.Services.AddSingleton<IDnsLookupService, SystemDnsLookupService>();

        builder.Services.Configure<DnsOptions>(builder.Configuration.GetSection(DnsOptions.SectionName));
        builder.Services.AddSingleton<FakeDnsResolutionService>();
        builder.Services.AddSingleton<DnsClientResolutionService>();
        builder.Services.AddScoped<IDnsResolutionService>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<DnsOptions>>().Value;
            if (string.Equals(options.Provider, "DnsClient", StringComparison.OrdinalIgnoreCase))
            {
                return sp.GetRequiredService<DnsClientResolutionService>();
            }

            return sp.GetRequiredService<FakeDnsResolutionService>();
        });

        builder.Services.Configure<DnsPropagationOptions>(builder.Configuration.GetSection(DnsPropagationOptions.SectionName));
        builder.Services.AddSingleton<FakeDnsPropagationChecker>();
        builder.Services.AddSingleton<DnsPropagationChecker>();
        builder.Services.AddScoped<IDnsPropagationChecker>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<DnsPropagationOptions>>().Value;
            return string.Equals(options.Provider, "Live", StringComparison.OrdinalIgnoreCase)
                ? sp.GetRequiredService<DnsPropagationChecker>()
                : sp.GetRequiredService<FakeDnsPropagationChecker>();
        });
        builder.Services.AddMemoryCache();
        builder.Services.AddHttpClient<IOsmStaticMapRenderer, OsmStaticMapRenderer>(client =>
        {
            client.DefaultRequestHeaders.UserAgent.ParseAdd("IPNote.ir/1.0 (+https://ipnote.ir; static-map)");
            client.DefaultRequestHeaders.Accept.ParseAdd("image/png");
            client.Timeout = TimeSpan.FromSeconds(20);
        });
        builder.Services.Configure<CacheOptions>(builder.Configuration.GetSection(CacheOptions.SectionName));
        builder.Services.AddSingleton<ICacheService>(sp => new TwoTierCacheService(
            sp.GetRequiredService<IMemoryCache>(),
            sp.GetRequiredService<IOptions<CacheOptions>>(),
            sp.GetRequiredService<ILogger<TwoTierCacheService>>(),
            sp.GetService<IDistributedCache>()));

        builder.Services.Configure<OutboxOptions>(builder.Configuration.GetSection(OutboxOptions.SectionName));
        builder.Services.AddScoped<IOutboxProcessor, Ntk.Note.IP.Infrastructure.Outbox.OutboxProcessor>();

        builder.Services.Configure<GeoIpOptions>(builder.Configuration.GetSection(GeoIpOptions.SectionName));
        builder.Services.AddSingleton<FakeGeoIpDatabase>();
        builder.Services.AddSingleton<MmdbGeoIpDatabase>();
        builder.Services.AddSingleton<IGeoIpDatabase>(sp =>
        {
            var geoOptions = sp.GetRequiredService<IOptions<GeoIpOptions>>().Value;
            if (IsOfflineGeoProvider(geoOptions.Provider))
            {
                var mmdb = sp.GetRequiredService<MmdbGeoIpDatabase>();
                if (mmdb.IsAvailable)
                {
                    return mmdb;
                }
            }

            return sp.GetRequiredService<FakeGeoIpDatabase>();
        });

        builder.Services.AddHangfire(configuration =>
        {
            if (OpenApiDocumentGeneration.IsActive)
            {
                configuration.UseMemoryStorage();
                return;
            }

            if (usePostgreSql)
            {
                configuration.UsePostgreSqlStorage(
                    options => options.UseNpgsqlConnection(connectionString),
                    new PostgreSqlStorageOptions
                    {
                        SchemaName = "hangfire"
                    });
            }
            else if (useSqlServer)
            {
                configuration.UseSqlServerStorage(connectionString, new SqlServerStorageOptions
                {
                    SchemaName = "HangFire",
                    PrepareSchemaIfNecessary = true,
                });
            }
            else
            {
                configuration.UseMemoryStorage();
            }
        });
        if (!OpenApiDocumentGeneration.IsActive)
        {
            builder.Services.AddHangfireServer();
            builder.Services.AddHostedService<HangfireJobRegistration>();
        }

        builder.Services.AddTransient<GeoIpDatabaseRefreshJob>();
        builder.Services.AddTransient<ProcessOutboxJob>();
        builder.Services.AddScoped<IPushIpMonitorPollService, PushIpMonitorPollService>();
        builder.Services.AddTransient<PushIpMonitorPollJob>();

        builder.Services.Configure<IpLookupOptions>(builder.Configuration.GetSection(IpLookupOptions.SectionName));
        builder.Services.AddHttpClient<IpApiLookupProvider>(client =>
        {
            client.Timeout = TimeSpan.FromSeconds(15);
        });
        builder.Services.AddHttpClient<IpWhoIsLookupProvider>(client =>
        {
            client.Timeout = TimeSpan.FromSeconds(15);
        });
        builder.Services.AddSingleton<FakeIpLookupProvider>();
        builder.Services.AddScoped<IIpLookupProvider>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<IpLookupOptions>>().Value;
            IIpLookupProvider inner = ResolveIpLookupProvider(sp, options.Provider);

            inner = new GeoEnrichedIpLookupProvider(
                inner,
                sp.GetRequiredService<IGeoIpDatabase>(),
                sp.GetRequiredService<ILogger<GeoEnrichedIpLookupProvider>>());

            return new CachedIpLookupProvider(
                inner,
                sp.GetRequiredService<ICacheService>(),
                sp.GetRequiredService<IOptions<CacheOptions>>());
        });

        builder.Services.Configure<WhoisOptions>(builder.Configuration.GetSection(WhoisOptions.SectionName));
        builder.Services.AddHttpClient<RdapWhoisProvider>(client =>
        {
            client.Timeout = TimeSpan.FromSeconds(20);
            client.DefaultRequestHeaders.UserAgent.ParseAdd("IPNote.ir/1.0 (+https://ipnote.ir; RDAP)");
        });
        builder.Services.AddSingleton<FakeWhoisProvider>();
        builder.Services.AddScoped<IWhoisProvider>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<WhoisOptions>>().Value;
            if (string.Equals(options.Provider, "Rdap", StringComparison.OrdinalIgnoreCase))
            {
                return sp.GetRequiredService<RdapWhoisProvider>();
            }

            return sp.GetRequiredService<FakeWhoisProvider>();
        });

        builder.Services.Configure<BlacklistOptions>(builder.Configuration.GetSection(BlacklistOptions.SectionName));
        builder.Services.AddSingleton<FakeBlacklistChecker>();
        builder.Services.AddSingleton<DnsblBlacklistChecker>();
        builder.Services.AddScoped<IBlacklistChecker>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<BlacklistOptions>>().Value;
            if (string.Equals(options.Provider, "Dnsbl", StringComparison.OrdinalIgnoreCase))
            {
                return sp.GetRequiredService<DnsblBlacklistChecker>();
            }

            return sp.GetRequiredService<FakeBlacklistChecker>();
        });

        builder.Services.Configure<NetworkToolsOptions>(builder.Configuration.GetSection(NetworkToolsOptions.SectionName));
        builder.Services.AddSingleton<TcpPortCheckService>();
        builder.Services.AddSingleton<FakePortCheckService>();
        builder.Services.AddScoped<IPortCheckService>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<NetworkToolsOptions>>().Value;
            return string.Equals(options.PortCheckProvider, "Tcp", StringComparison.OrdinalIgnoreCase)
                ? sp.GetRequiredService<TcpPortCheckService>()
                : sp.GetRequiredService<FakePortCheckService>();
        });

        builder.Services.AddSingleton<SslCertificateProbeService>();
        builder.Services.AddSingleton<FakeSslCertificateService>();
        builder.Services.AddScoped<ISslCertificateService>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<NetworkToolsOptions>>().Value;
            return string.Equals(options.SslProvider, "Probe", StringComparison.OrdinalIgnoreCase)
                ? sp.GetRequiredService<SslCertificateProbeService>()
                : sp.GetRequiredService<FakeSslCertificateService>();
        });

        builder.Services.Configure<PushOptions>(builder.Configuration.GetSection(PushOptions.SectionName));
        builder.Services.AddSingleton<NoOpPushSender>();
        builder.Services.AddSingleton<FirebasePushSender>();
        builder.Services.AddSingleton<IPushSender>(sp =>
        {
            var options = sp.GetRequiredService<IOptions<PushOptions>>().Value;
            return string.Equals(options.Provider, "Firebase", StringComparison.OrdinalIgnoreCase)
                ? sp.GetRequiredService<FirebasePushSender>()
                : sp.GetRequiredService<NoOpPushSender>();
        });
        builder.Services.AddScoped<IUserPushNotificationService, UserPushNotificationService>();
    }

    private static bool IsOfflineGeoProvider(string? provider) =>
        string.Equals(provider, "Mmdb", StringComparison.OrdinalIgnoreCase)
        || string.Equals(provider, "MaxMind", StringComparison.OrdinalIgnoreCase);

    private static IIpLookupProvider ResolveIpLookupProvider(IServiceProvider sp, string? provider)
    {
        if (string.Equals(provider, "IpApi", StringComparison.OrdinalIgnoreCase))
        {
            return sp.GetRequiredService<IpApiLookupProvider>();
        }

        if (string.Equals(provider, "IpWhoIs", StringComparison.OrdinalIgnoreCase))
        {
            return sp.GetRequiredService<IpWhoIsLookupProvider>();
        }

        return sp.GetRequiredService<FakeIpLookupProvider>();
    }
}
