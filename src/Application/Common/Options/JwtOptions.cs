namespace Ntk.Note.IP.Application.Common.Options;

/// <summary>
/// Identity bearer token settings (ASP.NET Core Identity API tokens for mobile/Flutter).
/// </summary>
public class JwtOptions
{
    public const string SectionName = "Jwt";

    /// <summary>Access token lifetime in hours (default 1).</summary>
    public int BearerTokenExpirationHours { get; set; } = 1;
}
