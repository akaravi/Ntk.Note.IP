using Ntk.Note.IP.Application.IpTools;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface ISslCertificateService
{
    Task<SslCertificateInfoDto> GetCertificateAsync(
        string normalizedDomain,
        int port,
        CancellationToken cancellationToken = default);
}
