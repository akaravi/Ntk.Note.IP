namespace Ntk.Note.IP.Web.Infrastructure;

public sealed class ClientRegistrationOptions
{
    /// <summary>
    /// HMAC secret for client attestation (min 32 bytes recommended). Override in User Secrets / env in production.
    /// </summary>
    public string Secret { get; set; } = string.Empty;

    /// <summary>
    /// Browser origins allowed for this client (merged into the global CORS policy).
    /// </summary>
    public string[] AllowedOrigins { get; set; } = [];
}
