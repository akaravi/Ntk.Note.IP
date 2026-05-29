using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Application.Common.Interfaces;

/// <summary>
/// External IP geo/ASN lookup (ip-api, MaxMind, etc.).
/// </summary>
public interface IIpLookupProvider
{
    Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default);
}
