using System.Net.Http.Json;
using System.Text.Json;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.IpLookup;

/// <summary>
/// Free-tier ip-api.com JSON lookup (non-commercial; rate-limited).
/// </summary>
public sealed class IpApiLookupProvider(HttpClient httpClient) : IIpLookupProvider
{
    private const string Fields =
        "status,message,country,countryCode,regionName,city,lat,lon,timezone,isp,org,as,proxy,hosting,mobile,query";

    public async Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var url =
            $"http://ip-api.com/json/{Uri.EscapeDataString(normalizedAddress)}?fields={Fields}";

        var response = await httpClient.GetFromJsonAsync<IpApiResponse>(url, cancellationToken);

        if (response is null || !string.Equals(response.Status, "success", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(response?.Message ?? "IP lookup provider returned no data.");
        }

        var payload = JsonSerializer.Serialize(response);

        return new IpLookupResultDto
        {
            Address = response.Query ?? normalizedAddress,
            CountryCode = response.CountryCode,
            Country = response.Country,
            Region = response.RegionName,
            City = response.City,
            Latitude = response.Lat,
            Longitude = response.Lon,
            Timezone = response.Timezone,
            Asn = response.As,
            Isp = response.Isp ?? response.Org,
            Proxy = response.Proxy,
            Hosting = response.Hosting,
            Mobile = response.Mobile,
            Tor = false,
            ProviderPayload = payload
        };
    }

    private sealed class IpApiResponse
    {
        public string? Status { get; set; }

        public string? Message { get; set; }

        public string? Country { get; set; }

        public string? CountryCode { get; set; }

        public string? RegionName { get; set; }

        public string? City { get; set; }

        public double? Lat { get; set; }

        public double? Lon { get; set; }

        public string? Timezone { get; set; }

        public string? Isp { get; set; }

        public string? Org { get; set; }

        public string? As { get; set; }

        public bool? Proxy { get; set; }

        public bool? Hosting { get; set; }

        public bool? Mobile { get; set; }

        public string? Query { get; set; }
    }
}
