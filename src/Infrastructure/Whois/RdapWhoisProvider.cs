using System.Text.Json;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Whois;

namespace Ntk.Note.IP.Infrastructure.Whois;

public sealed class RdapWhoisProvider(HttpClient httpClient) : IWhoisProvider
{
    public async Task<WhoisIpDto> LookupIpAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var url = $"https://rdap.org/ip/{Uri.EscapeDataString(normalizedAddress)}";
        using var response = await httpClient.GetAsync(url, cancellationToken);
        response.EnsureSuccessStatusCode();

        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        using var document = await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken);
        var root = document.RootElement;

        var payload = root.GetRawText();
        DateTimeOffset? registered = null;
        if (root.TryGetProperty("events", out var events))
        {
            foreach (var evt in events.EnumerateArray())
            {
                if (evt.TryGetProperty("eventAction", out var action)
                    && action.GetString() == "registration"
                    && evt.TryGetProperty("eventDate", out var date))
                {
                    if (DateTimeOffset.TryParse(date.GetString(), out var parsed))
                    {
                        registered = parsed;
                    }
                }
            }
        }

        return new WhoisIpDto
        {
            Address = normalizedAddress,
            Handle = root.TryGetProperty("handle", out var handle) ? handle.GetString() : null,
            Name = root.TryGetProperty("name", out var name) ? name.GetString() : null,
            Country = root.TryGetProperty("country", out var country) ? country.GetString() : null,
            StartAddress = root.TryGetProperty("startAddress", out var start) ? start.GetString() : null,
            EndAddress = root.TryGetProperty("endAddress", out var end) ? end.GetString() : null,
            Type = root.TryGetProperty("type", out var type) ? type.GetString() : null,
            RegistrationDate = registered,
            RawPayload = payload
        };
    }

    public async Task<WhoisDomainDto> LookupDomainAsync(string normalizedDomain, CancellationToken cancellationToken = default)
    {
        var url = $"https://rdap.org/domain/{Uri.EscapeDataString(normalizedDomain.ToUpperInvariant())}";
        using var response = await httpClient.GetAsync(url, cancellationToken);
        response.EnsureSuccessStatusCode();

        await using var stream = await response.Content.ReadAsStreamAsync(cancellationToken);
        using var document = await JsonDocument.ParseAsync(stream, cancellationToken: cancellationToken);
        var root = document.RootElement;
        var payload = root.GetRawText();

        var nameServers = new List<string>();
        if (root.TryGetProperty("nameservers", out var nsArray))
        {
            foreach (var ns in nsArray.EnumerateArray())
            {
                if (ns.TryGetProperty("ldhName", out var ldh))
                {
                    var value = ldh.GetString();
                    if (!string.IsNullOrWhiteSpace(value))
                    {
                        nameServers.Add(value.TrimEnd('.'));
                    }
                }
            }
        }

        DateTimeOffset? registered = null;
        DateTimeOffset? expires = null;
        if (root.TryGetProperty("events", out var events))
        {
            foreach (var evt in events.EnumerateArray())
            {
                if (!evt.TryGetProperty("eventAction", out var action)
                    || !evt.TryGetProperty("eventDate", out var date)
                    || !DateTimeOffset.TryParse(date.GetString(), out var parsed))
                {
                    continue;
                }

                var actionName = action.GetString();
                if (actionName == "registration")
                {
                    registered = parsed;
                }
                else if (actionName == "expiration")
                {
                    expires = parsed;
                }
            }
        }

        var status = root.TryGetProperty("status", out var statusArray)
            ? string.Join(", ", statusArray.EnumerateArray().Select(s => s.GetString()).Where(s => s is not null))
            : null;

        return new WhoisDomainDto
        {
            Domain = normalizedDomain,
            Handle = root.TryGetProperty("handle", out var handle) ? handle.GetString() : null,
            Name = root.TryGetProperty("ldhName", out var ldhName) ? ldhName.GetString()?.TrimEnd('.') : normalizedDomain,
            NameServers = [..nameServers],
            Status = status,
            RegistrationDate = registered,
            ExpirationDate = expires,
            RawPayload = payload
        };
    }
}
