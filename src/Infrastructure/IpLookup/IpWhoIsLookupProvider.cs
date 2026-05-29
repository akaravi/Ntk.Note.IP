using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Serialization;
using Microsoft.Extensions.Logging;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.IpLookup;

/// <summary>
/// HTTPS lookup via ipwho.is (works when outbound HTTP to ip-api.com is blocked).
/// </summary>
public sealed class IpWhoIsLookupProvider(
    HttpClient httpClient,
    ILogger<IpWhoIsLookupProvider> logger) : IIpLookupProvider
{
    public async Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var url = $"https://ipwho.is/{Uri.EscapeDataString(normalizedAddress)}";

        HttpResponseMessage response;
        try
        {
            response = await httpClient.GetAsync(url, cancellationToken);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            logger.LogWarning(ex, "ipwho.is request failed for {Address}", normalizedAddress);
            throw new InvalidOperationException("IP lookup provider request failed.", ex);
        }

        if (!response.IsSuccessStatusCode)
        {
            logger.LogWarning(
                "ipwho.is returned {StatusCode} for {Address}",
                (int)response.StatusCode,
                normalizedAddress);
            throw new InvalidOperationException($"IP lookup provider returned {(int)response.StatusCode}.");
        }

        var payload = await response.Content.ReadFromJsonAsync<IpWhoIsResponse>(cancellationToken);
        if (payload is null || !payload.Success)
        {
            throw new InvalidOperationException(payload?.Message ?? "IP lookup provider returned no data.");
        }

        var raw = JsonSerializer.Serialize(payload);
        var asn = payload.Connection?.Asn is int asnNumber
            ? $"AS{asnNumber} {payload.Connection.Org}".Trim()
            : payload.Connection?.Org;

        return new IpLookupResultDto
        {
            Address = payload.Ip ?? normalizedAddress,
            CountryCode = payload.CountryCode,
            Country = payload.Country,
            Region = payload.Region,
            City = payload.City,
            Latitude = payload.Latitude,
            Longitude = payload.Longitude,
            Timezone = payload.Timezone?.Id,
            Asn = asn,
            Isp = payload.Connection?.Isp ?? payload.Connection?.Org,
            Proxy = payload.Security?.Proxy,
            Hosting = payload.Security?.Hosting,
            Mobile = payload.Connection?.Type?.Contains("mobile", StringComparison.OrdinalIgnoreCase),
            Tor = payload.Security?.Tor,
            ProviderPayload = raw
        };
    }

    private sealed class IpWhoIsResponse
    {
        public bool Success { get; set; }

        public string? Message { get; set; }

        public string? Ip { get; set; }

        public string? Country { get; set; }

        [JsonPropertyName("country_code")]
        public string? CountryCode { get; set; }

        public string? Region { get; set; }

        public string? City { get; set; }

        public double? Latitude { get; set; }

        public double? Longitude { get; set; }

        public IpWhoIsConnection? Connection { get; set; }

        public IpWhoIsTimezone? Timezone { get; set; }

        public IpWhoIsSecurity? Security { get; set; }
    }

    private sealed class IpWhoIsConnection
    {
        public int? Asn { get; set; }

        public string? Org { get; set; }

        public string? Isp { get; set; }

        public string? Type { get; set; }
    }

    private sealed class IpWhoIsTimezone
    {
        public string? Id { get; set; }
    }

    private sealed class IpWhoIsSecurity
    {
        public bool? Proxy { get; set; }

        public bool? Hosting { get; set; }

        public bool? Tor { get; set; }
    }
}
