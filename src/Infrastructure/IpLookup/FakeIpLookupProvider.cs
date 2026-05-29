using System.Text.Json;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.IpLookup;

/// <summary>
/// Deterministic lookup for development and automated tests (no external HTTP).
/// </summary>
public sealed class FakeIpLookupProvider : IIpLookupProvider
{
    public Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var payload = JsonSerializer.Serialize(new
        {
            provider = "Fake",
            query = normalizedAddress,
            status = "success"
        });

        var result = new IpLookupResultDto
        {
            Address = normalizedAddress,
            CountryCode = "IR",
            Country = "Iran",
            Region = "Tehran",
            City = "Tehran",
            Latitude = 35.6892,
            Longitude = 51.3890,
            Timezone = "Asia/Tehran",
            Asn = "AS44244 Iran Cell",
            Isp = "Irancell",
            Proxy = false,
            Hosting = false,
            Mobile = true,
            Tor = false,
            ProviderPayload = payload
        };

        return Task.FromResult(result);
    }
}
