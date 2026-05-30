namespace Ntk.Note.IP.Application.Common.Options;

/// <summary>
/// Public site settings (contact destination, branding).
/// </summary>
public class SiteOptions
{
    public const string SectionName = "Site";

    /// <summary>Inbound contact form email destination.</summary>
    public string ContactToEmail { get; set; } = string.Empty;

    public string ContactFromEmail { get; set; } = "noreply@localhost";

    public string ContactFromName { get; set; } = "IPNote Contact";
}
