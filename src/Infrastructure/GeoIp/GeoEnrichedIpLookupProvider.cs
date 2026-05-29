using Microsoft.Extensions.Logging;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.GeoIp;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.GeoIp;

/// <summary>
/// Merges offline MMDB/Fake geo into online provider results when fields are missing.
/// Falls back to offline geo when the online provider fails.
/// </summary>
public sealed class GeoEnrichedIpLookupProvider(
    IIpLookupProvider inner,
    IGeoIpDatabase geoIpDatabase,
    ILogger<GeoEnrichedIpLookupProvider> logger) : IIpLookupProvider
{
    public async Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        IpLookupResultDto result;
        try
        {
            result = await inner.LookupAsync(normalizedAddress, cancellationToken);
        }
        catch (Exception ex) when (ex is not OperationCanceledException)
        {
            logger.LogWarning(
                ex,
                "Online IP lookup failed for {Address}; using offline geo fallback.",
                normalizedAddress);
            result = new IpLookupResultDto { Address = normalizedAddress };
        }

        var offline = await geoIpDatabase.TryLookupAsync(normalizedAddress, cancellationToken);
        if (offline is null)
        {
            return result;
        }

        return Merge(result, offline);
    }

    private static IpLookupResultDto Merge(IpLookupResultDto result, GeoIpLookupResult offline) =>
        new()
        {
            Address = result.Address,
            CountryCode = result.CountryCode ?? offline.CountryCode,
            Country = result.Country ?? offline.Country,
            Region = result.Region ?? offline.Region,
            City = result.City ?? offline.City,
            Latitude = result.Latitude ?? offline.Latitude,
            Longitude = result.Longitude ?? offline.Longitude,
            Timezone = result.Timezone ?? offline.Timezone,
            Asn = result.Asn,
            Isp = result.Isp,
            Proxy = result.Proxy,
            Hosting = result.Hosting,
            Mobile = result.Mobile,
            Tor = result.Tor,
            ProviderPayload = result.ProviderPayload
        };
}
