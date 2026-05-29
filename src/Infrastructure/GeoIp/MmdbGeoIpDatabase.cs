using System.Net;
using MaxMind.GeoIP2;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Application.GeoIp;

namespace Ntk.Note.IP.Infrastructure.GeoIp;

public sealed class MmdbGeoIpDatabase : IGeoIpDatabase, IDisposable
{
    private readonly FakeGeoIpDatabase _fallback = new();
    private readonly ILogger<MmdbGeoIpDatabase> _logger;
    private DatabaseReader? _reader;

    public MmdbGeoIpDatabase(IOptions<GeoIpOptions> options, ILogger<MmdbGeoIpDatabase> logger)
    {
        _logger = logger;
        var path = options.Value.MmdbPath;
        if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
        {
            _logger.LogWarning("GeoIP MMDB file not found at {MmdbPath}. Offline lookups use Fake fallback.", path);
            return;
        }

        try
        {
            _reader = new DatabaseReader(path);
            _logger.LogInformation("GeoIP MMDB loaded from {MmdbPath}", path);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to open GeoIP MMDB at {MmdbPath}", path);
        }
    }

    public bool IsAvailable => _reader is not null;

    public async Task<GeoIpLookupResult?> TryLookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        if (_reader is null || !IPAddress.TryParse(normalizedAddress, out var ipAddress))
        {
            return await _fallback.TryLookupAsync(normalizedAddress, cancellationToken);
        }

        cancellationToken.ThrowIfCancellationRequested();

        try
        {
            var city = _reader.City(ipAddress);
            return new GeoIpLookupResult
            {
                Address = normalizedAddress,
                CountryCode = city.Country?.IsoCode,
                Country = city.Country?.Name,
                Region = city.MostSpecificSubdivision?.Name,
                City = city.City?.Name,
                Latitude = city.Location?.Latitude,
                Longitude = city.Location?.Longitude,
                Timezone = city.Location?.TimeZone,
                Source = "MMDB"
            };
        }
        catch (Exception ex)
        {
            _logger.LogDebug(ex, "MMDB lookup failed for {Address}", normalizedAddress);
            return await _fallback.TryLookupAsync(normalizedAddress, cancellationToken);
        }
    }

    public void Dispose() => _reader?.Dispose();
}
