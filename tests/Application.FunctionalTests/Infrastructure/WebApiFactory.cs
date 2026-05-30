using Microsoft.Extensions.Hosting;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Infrastructure.Blacklist;
using Ntk.Note.IP.Infrastructure.DnsResolution;
using Ntk.Note.IP.Infrastructure.IpLookup;
using Ntk.Note.IP.Infrastructure.Whois;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

public class WebApiFactory(string connectionString) : WebApplicationFactory<Program>
{
    internal static TestClientIpResolver ClientIpResolver { get; } = new("203.0.113.25");

    internal static TrackingPushSender PushSender { get; } = new();

    protected override IHost CreateHost(IHostBuilder builder)
    {
        TestDatabaseMigrator.EnsureLatestSchema(connectionString);
        return base.CreateHost(builder);
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment(Environments.Development);

        builder
            .UseSetting("ConnectionStrings:IPNoteDb", connectionString);

        builder.UseSetting("Push:Enabled", "true");

        builder.ConfigureTestServices(services =>
        {
            services
                .RemoveAll<IUser>()
                .AddTransient(provider =>
                {
                    var mock = new Mock<IUser>();
                    mock.SetupGet(x => x.Roles).Returns(TestApp.GetRoles());
                    mock.SetupGet(x => x.Id).Returns(TestApp.GetUserId());
                    return mock.Object;
                });

            services
                .RemoveAll<IClientIpResolver>()
                .AddSingleton<IClientIpResolver>(ClientIpResolver);

            services
                .RemoveAll<IPushSender>()
                .AddSingleton<IPushSender>(PushSender);

            services.RemoveAll<IIpLookupProvider>();
            services.AddSingleton<IIpLookupProvider, FakeIpLookupProvider>();

            services.RemoveAll<IDnsLookupService>();
            services.AddSingleton<IDnsLookupService, TestDnsLookupService>();

            services.RemoveAll<IDnsResolutionService>();
            services.AddSingleton<IDnsResolutionService, FakeDnsResolutionService>();

            services.RemoveAll<IDnsPropagationChecker>();
            services.AddSingleton<IDnsPropagationChecker, FakeDnsPropagationChecker>();

            services.RemoveAll<IWhoisProvider>();
            services.AddSingleton<IWhoisProvider, FakeWhoisProvider>();

            services.RemoveAll<IBlacklistChecker>();
            services.AddSingleton<IBlacklistChecker, FakeBlacklistChecker>();
        });
    }

    /// <summary>
    /// Production middleware/pipeline checks while keeping Aspire SQLite test DB (not SqlServer).
    /// </summary>
    protected static void ConfigureProductionTestHost(IWebHostBuilder builder)
    {
        builder.UseEnvironment(Environments.Production);
        builder.UseSetting("Database:Provider", "Sqlite");
        builder.UseSetting("Database:ApplyMigrationsOnStartup", "false");
    }
}
