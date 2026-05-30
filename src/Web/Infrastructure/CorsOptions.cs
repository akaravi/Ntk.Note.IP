namespace Ntk.Note.IP.Web.Infrastructure;

public sealed class CorsOptions
{
    public const string SectionName = "Cors";

    /// <summary>
    /// Extra browser origins merged with all <c>Clients:*:AllowedOrigins</c>.
    /// Prefer registering origins under <c>Clients</c> (panel-web, flutter-app).
    /// </summary>
    public string[] AllowedOrigins { get; set; } = [];
}
