using System.Threading.RateLimiting;
using Azure.Identity;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Infrastructure.Data;
using Ntk.Note.IP.Web.Infrastructure;
using Ntk.Note.IP.Web.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.RateLimiting;

namespace Microsoft.Extensions.DependencyInjection;

public static class DependencyInjection
{
    public static void AddWebServices(this IHostApplicationBuilder builder)
    {
        builder.Services.AddDatabaseDeveloperPageExceptionFilter();

        builder.Services.AddScoped<IUser, CurrentUser>();
        builder.Services.AddScoped<IClientIpResolver, ClientIpResolver>();

        builder.Services.AddHttpContextAccessor();

        builder.Services.AddExceptionHandler<ProblemDetailsExceptionHandler>();

        // Customise default API behaviour
        builder.Services.Configure<ApiBehaviorOptions>(options =>
            options.SuppressModelStateInvalidFilter = true);

        builder.Services.AddEndpointsApiExplorer();

        builder.Services.AddOpenApi(options =>
        {
            options.AddOperationTransformer<ApiExceptionOperationTransformer>();
            options.AddOperationTransformer<IdentityApiOperationTransformer>();
            options.AddDocumentTransformer<BearerSecuritySchemeTransformer>();
        });

        builder.Services.Configure<CorsOptions>(builder.Configuration.GetSection(CorsOptions.SectionName));
        builder.Services.Configure<Dictionary<string, ClientRegistrationOptions>>(
            builder.Configuration.GetSection(ClientsConfigurationExtensions.ClientsSectionName));
        builder.Services.AddSingleton<IRegisteredClientStore, RegisteredClientStore>();
        builder.Services.AddSingleton<ClientHmacValidator>();

        var normalizedOrigins = builder.Configuration.GetMergedCorsOrigins();

        builder.Services.AddCors(options =>
        {
            if (normalizedOrigins.Length > 0)
            {
                options.AddDefaultPolicy(policy => policy
                    .WithOrigins(normalizedOrigins)
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .AllowCredentials()
                    .SetPreflightMaxAge(TimeSpan.FromHours(24)));
            }
            else if (builder.Environment.IsDevelopment())
            {
                options.AddDefaultPolicy(policy => policy
                    .AllowAnyMethod()
                    .AllowAnyHeader()
                    .AllowAnyOrigin());
            }
        });

        var guestPermitLimit = builder.Configuration.GetValue("RateLimiting:GuestPermitLimit", 60);
        var guestWindowMinutes = builder.Configuration.GetValue("RateLimiting:GuestWindowMinutes", 1);
        var authPermitLimit = builder.Configuration.GetValue("RateLimiting:AuthPermitLimit", 10);
        var authWindowMinutes = builder.Configuration.GetValue("RateLimiting:AuthWindowMinutes", 5);

        builder.Services.AddRateLimiter(options =>
        {
            options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;
            options.AddPolicy(GuestRateLimitPolicies.GuestApi, httpContext =>
            {
                if (httpContext.User.Identity?.IsAuthenticated == true)
                {
                    return RateLimitPartition.GetNoLimiter("authenticated");
                }

                var partitionKey = httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";
                return RateLimitPartition.GetFixedWindowLimiter(
                    partitionKey,
                    _ => new FixedWindowRateLimiterOptions
                    {
                        AutoReplenishment = true,
                        PermitLimit = guestPermitLimit,
                        Window = TimeSpan.FromMinutes(guestWindowMinutes),
                        QueueLimit = 0
                    });
            });

            options.AddPolicy(GuestRateLimitPolicies.AuthSensitive, httpContext =>
            {
                if (!IsAuthSensitiveRequest(httpContext))
                {
                    return RateLimitPartition.GetNoLimiter("auth-not-sensitive");
                }

                var partitionKey = httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown";
                return RateLimitPartition.GetFixedWindowLimiter(
                    partitionKey,
                    _ => new FixedWindowRateLimiterOptions
                    {
                        AutoReplenishment = true,
                        PermitLimit = authPermitLimit,
                        Window = TimeSpan.FromMinutes(authWindowMinutes),
                        QueueLimit = 0
                    });
            });
        });
    }

    private static bool IsAuthSensitiveRequest(HttpContext httpContext)
    {
        if (!HttpMethods.IsPost(httpContext.Request.Method))
        {
            return false;
        }

        var path = httpContext.Request.Path.Value ?? string.Empty;
        return path.EndsWith("/login", StringComparison.OrdinalIgnoreCase)
            || path.EndsWith("/register", StringComparison.OrdinalIgnoreCase)
            || path.EndsWith("/forgotPassword", StringComparison.OrdinalIgnoreCase)
            || path.EndsWith("/resetPassword", StringComparison.OrdinalIgnoreCase);
    }

    public static void AddKeyVaultIfConfigured(this IHostApplicationBuilder builder)
    {
        var keyVaultUri = builder.Configuration["AZURE_KEY_VAULT_ENDPOINT"];
        if (!string.IsNullOrWhiteSpace(keyVaultUri))
        {
            builder.Configuration.AddAzureKeyVault(
                new Uri(keyVaultUri),
                new DefaultAzureCredential());
        }
    }
}
