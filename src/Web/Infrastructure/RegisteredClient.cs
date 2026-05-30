namespace Ntk.Note.IP.Web.Infrastructure;

public sealed record RegisteredClient(
    string ClientId,
    string Secret,
    IReadOnlyList<string> AllowedOrigins);
