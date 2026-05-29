using Ntk.Note.IP.Application.Dns;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IDnsPropagationChecker
{
    Task<DnsPropagationResultDto> CheckAsync(
        string normalizedDomain,
        DnsRecordType recordType,
        CancellationToken cancellationToken = default);
}
