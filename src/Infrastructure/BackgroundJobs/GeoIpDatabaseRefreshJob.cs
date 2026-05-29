using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
namespace Ntk.Note.IP.Infrastructure.BackgroundJobs;

public sealed class GeoIpDatabaseRefreshJob(
    IGeoIpDatabase geoIpDatabase,
    IOptions<GeoIpOptions> geoIpOptions,
    ILogger<GeoIpDatabaseRefreshJob> logger)
{
    public async Task ExecuteAsync(CancellationToken cancellationToken = default)
    {
        var options = geoIpOptions.Value;
        logger.LogInformation("GeoIP database refresh job started (provider {Provider}).", options.Provider);

        if (string.Equals(options.Provider, "Mmdb", StringComparison.OrdinalIgnoreCase))
        {
            var path = options.MmdbPath;
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                logger.LogWarning(
                    "MMDB file missing at {MmdbPath}. Download GeoLite2-City.mmdb and set GeoIp:MmdbPath. See docs/geo/mmdb-setup.md",
                    path);
            }
            else
            {
                logger.LogInformation("MMDB file present at {MmdbPath} ({SizeBytes} bytes).", path, new FileInfo(path).Length);
            }
        }

        _ = await geoIpDatabase.TryLookupAsync("1.1.1.1", cancellationToken);
        logger.LogInformation("GeoIP database refresh job completed.");
    }
}
