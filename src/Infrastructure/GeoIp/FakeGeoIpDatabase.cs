using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.GeoIp;

namespace Ntk.Note.IP.Infrastructure.GeoIp;

/// <summary>
/// Deterministic offline geo data for development and tests.
/// </summary>
public sealed class FakeGeoIpDatabase : IGeoIpDatabase
{
    public Task<GeoIpLookupResult?> TryLookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        if (normalizedAddress.StartsWith("10.", StringComparison.Ordinal) ||
            normalizedAddress.StartsWith("192.168.", StringComparison.Ordinal))
        {
            return Task.FromResult<GeoIpLookupResult?>(new GeoIpLookupResult
            {
                Address = normalizedAddress,
                CountryCode = "—",
                Country = "Private",
                Region = "LAN",
                City = "Private",
                Source = "Fake-private"
            });
        }

        return Task.FromResult<GeoIpLookupResult?>(new GeoIpLookupResult
        {
            Address = normalizedAddress,
            CountryCode = "IR",
            Country = "Iran",
            Region = "Tehran",
            City = "Tehran",
            Latitude = 35.6892,
            Longitude = 51.3890,
            Timezone = "Asia/Tehran",
            Source = "Fake"
        });
    }
}
