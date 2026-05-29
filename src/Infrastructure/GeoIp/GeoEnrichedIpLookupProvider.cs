using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.GeoIp;

/// <summary>
/// Merges offline MMDB/Fake geo into online provider results when fields are missing.
/// </summary>
public sealed class GeoEnrichedIpLookupProvider(
    IIpLookupProvider inner,
    IGeoIpDatabase geoIpDatabase) : IIpLookupProvider
{
    public async Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var result = await inner.LookupAsync(normalizedAddress, cancellationToken);
        var offline = await geoIpDatabase.TryLookupAsync(normalizedAddress, cancellationToken);
        if (offline is null)
        {
            return result;
        }

        return new IpLookupResultDto
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
}
