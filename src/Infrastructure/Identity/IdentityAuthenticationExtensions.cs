using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.BearerToken;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.Identity;

public static class IdentityAuthenticationExtensions
{
    public const string SmartAuthScheme = "Smart";

    public static IServiceCollection AddIpNoteAuthentication(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        var jwt = configuration.GetSection(JwtOptions.SectionName).Get<JwtOptions>() ?? new JwtOptions();
        var bearerExpiration = TimeSpan.FromHours(Math.Max(1, jwt.BearerTokenExpirationHours));

        services
            .AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = SmartAuthScheme;
                options.DefaultChallengeScheme = IdentityConstants.BearerScheme;
                options.DefaultSignInScheme = IdentityConstants.ExternalScheme;
            })
            .AddPolicyScheme(SmartAuthScheme, "Cookie or Bearer", policy =>
            {
                policy.ForwardDefaultSelector = context =>
                {
                    var authorization = context.Request.Headers.Authorization.ToString();
                    if (authorization.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase))
                    {
                        return IdentityConstants.BearerScheme;
                    }

                    return IdentityConstants.ApplicationScheme;
                };
            })
            .AddBearerToken(IdentityConstants.BearerScheme, options =>
            {
                options.BearerTokenExpiration = bearerExpiration;
            })
            .AddIdentityCookies();

        return services;
    }
}
