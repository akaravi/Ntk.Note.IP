using System.Net.Http.Json;
using System.Text.Json;
using Microsoft.Extensions.Logging;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.IpLookup;

/// <summary>
/// Free-tier ip-api.com JSON lookup (non-commercial; rate-limited; HTTP only on free tier).
/// </summary>
public sealed class IpApiLookupProvider(
    HttpClient httpClient,
    ILogger<IpApiLookupProvider> logger) : IIpLookupProvider
{
    private const string Fields =
        "status,message,country,countryCode,regionName,city,lat,lon,timezone,isp,org,as,proxy,hosting,mobile,query";

    public async Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var url =
            $"http://ip-api.com/json/{Uri.EscapeDataString(normalizedAddress)}?fields={Fields}";

        HttpResponseMessage response;
        try
        {
            response = await httpClient.GetAsync(url, cancellationToken);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            logger.LogWarning(ex, "ip-api.com request failed for {Address}", normalizedAddress);
            throw new InvalidOperationException("IP lookup provider request failed.", ex);
        }

        if (!response.IsSuccessStatusCode)
        {
            logger.LogWarning(
                "ip-api.com returned {StatusCode} for {Address}",
                (int)response.StatusCode,
                normalizedAddress);
            throw new InvalidOperationException($"IP lookup provider returned {(int)response.StatusCode}.");
        }

        var payload = await response.Content.ReadFromJsonAsync<IpApiResponse>(cancellationToken);
        if (payload is null || !string.Equals(payload.Status, "success", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(payload?.Message ?? "IP lookup provider returned no data.");
        }

        var raw = JsonSerializer.Serialize(payload);

        return new IpLookupResultDto
        {
            Address = payload.Query ?? normalizedAddress,
            CountryCode = payload.CountryCode,
            Country = payload.Country,
            Region = payload.RegionName,
            City = payload.City,
            Latitude = payload.Lat,
            Longitude = payload.Lon,
            Timezone = payload.Timezone,
            Asn = payload.As,
            Isp = payload.Isp ?? payload.Org,
            Proxy = payload.Proxy,
            Hosting = payload.Hosting,
            Mobile = payload.Mobile,
            Tor = false,
            ProviderPayload = raw
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
