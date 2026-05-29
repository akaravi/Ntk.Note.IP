using Ntk.Note.IP.Application.Dns;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IDnsResolutionService
{
    Task<DnsResolveResultDto> ResolveAsync(
        string normalizedDomain,
        IReadOnlyCollection<DnsRecordType> recordTypes,
        CancellationToken cancellationToken = default);
}
