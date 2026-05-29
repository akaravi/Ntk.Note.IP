using Ntk.Note.IP.Application.GeoIp;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IGeoIpDatabase
{
    Task<GeoIpLookupResult?> TryLookupAsync(string normalizedAddress, CancellationToken cancellationToken = default);
}
