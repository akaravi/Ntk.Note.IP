using Microsoft.Extensions.Options;

namespace Ntk.Note.IP.Web.Infrastructure;

public sealed class RegisteredClientStore : IRegisteredClientStore
{
    private IReadOnlyDictionary<string, RegisteredClient> _clients;

    public RegisteredClientStore(IOptionsMonitor<Dictionary<string, ClientRegistrationOptions>> optionsMonitor)
    {
        _clients = BuildClients(optionsMonitor.CurrentValue);
        optionsMonitor.OnChange(registrations => _clients = BuildClients(registrations));
    }

    public bool TryGet(string clientId, out RegisteredClient client)
    {
        if (string.IsNullOrWhiteSpace(clientId))
        {
            client = null!;
            return false;
        }

        return _clients.TryGetValue(clientId.Trim(), out client!);
    }

    public IReadOnlyCollection<RegisteredClient> GetAll() => _clients.Values.ToArray();

    public IReadOnlyCollection<string> GetAllCorsOrigins()
    {
        return _clients.Values
            .SelectMany(static client => client.AllowedOrigins)
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }

    private static IReadOnlyDictionary<string, RegisteredClient> BuildClients(
        Dictionary<string, ClientRegistrationOptions>? registrations)
    {
        if (registrations is null || registrations.Count == 0)
        {
            return new Dictionary<string, RegisteredClient>(StringComparer.OrdinalIgnoreCase);
        }

        var clients = new Dictionary<string, RegisteredClient>(StringComparer.OrdinalIgnoreCase);

        foreach (var (clientId, options) in registrations)
        {
            if (string.IsNullOrWhiteSpace(clientId))
            {
                continue;
            }

            var origins = (options.AllowedOrigins ?? [])
                .Select(static origin => origin.Trim())
                .Where(static origin => origin.Length > 0)
                .Distinct(StringComparer.OrdinalIgnoreCase)
                .ToArray();

            clients[clientId.Trim()] = new RegisteredClient(
                clientId.Trim(),
                options.Secret?.Trim() ?? string.Empty,
                origins);
        }

        return clients;
    }
}
