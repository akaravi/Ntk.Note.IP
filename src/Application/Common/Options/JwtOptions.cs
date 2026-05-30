namespace Ntk.Note.IP.Application.Common.Options;

/// <summary>
/// Identity bearer token settings (ASP.NET Core Identity API tokens for mobile/Flutter).
/// </summary>
public class JwtOptions
{
    public const string SectionName = "Jwt";

    /// <summary>Access token lifetime in hours (default 1).</summary>
    public int BearerTokenExpirationHours { get; set; } = 1;

    /// <summary>Refresh token lifetime in days when "remember me" is enabled (default 30).</summary>
    public int RefreshTokenExpirationDays { get; set; } = 30;

    /// <summary>Auth cookie lifetime in days for persistent web sign-in (default 30).</summary>
    public int CookieRememberMeDays { get; set; } = 30;
}
