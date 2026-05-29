namespace Ntk.Note.IP.Web.Infrastructure;

public sealed class CorsOptions
{
    public const string SectionName = "Cors";

    /// <summary>
    /// Explicit browser origins. Empty in base appsettings: Development uses appsettings.Development.json;
    /// Production uses appsettings.Production.json (e.g. https://ipnote.ir).
    /// </summary>
    public string[] AllowedOrigins { get; set; } = [];
}
