namespace Ntk.Note.IP.Web.Infrastructure;

public static class ClientsConfigurationExtensions
{
    public const string ClientsSectionName = "Clients";

    public static IReadOnlyDictionary<string, ClientRegistrationOptions> GetClientRegistrations(
        this IConfiguration configuration)
    {
        var registrations = configuration
            .GetSection(ClientsSectionName)
            .Get<Dictionary<string, ClientRegistrationOptions>>();

        return registrations is null || registrations.Count == 0
            ? new Dictionary<string, ClientRegistrationOptions>(StringComparer.OrdinalIgnoreCase)
            : new Dictionary<string, ClientRegistrationOptions>(registrations, StringComparer.OrdinalIgnoreCase);
    }

    public static string[] GetMergedCorsOrigins(this IConfiguration configuration)
    {
        var fromClients = configuration
            .GetClientRegistrations()
            .Values
            .SelectMany(static client => client.AllowedOrigins ?? [])
            .Select(static origin => origin.Trim())
            .Where(static origin => origin.Length > 0);

        var legacyCors = configuration
            .GetSection(CorsOptions.SectionName)
            .Get<CorsOptions>()?
            .AllowedOrigins ?? [];

        var fromLegacy = legacyCors
            .Select(static origin => origin.Trim())
            .Where(static origin => origin.Length > 0);

        return fromClients
            .Concat(fromLegacy)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }
}
