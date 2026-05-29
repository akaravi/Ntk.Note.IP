using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpTools;

namespace Ntk.Note.IP.Infrastructure.NetworkTools;

public sealed class FakeSslCertificateService : ISslCertificateService
{
    public Task<SslCertificateInfoDto> GetCertificateAsync(
        string normalizedDomain,
        int port,
        CancellationToken cancellationToken = default)
    {
        var now = DateTimeOffset.UtcNow;
        return Task.FromResult(new SslCertificateInfoDto
        {
            Host = normalizedDomain,
            Port = port,
            Subject = $"CN={normalizedDomain}",
            Issuer = "CN=Fake CA",
            NotBefore = now.AddDays(-30),
            NotAfter = now.AddDays(335),
            Thumbprint = "FAKE0123456789",
            IsValidNow = true
        });
    }
}
