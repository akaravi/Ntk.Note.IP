using System.Net.Security;
using System.Net.Sockets;
using System.Security.Cryptography.X509Certificates;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpTools;

namespace Ntk.Note.IP.Infrastructure.NetworkTools;

public sealed class SslCertificateProbeService : ISslCertificateService
{
    public async Task<SslCertificateInfoDto> GetCertificateAsync(
        string normalizedDomain,
        int port,
        CancellationToken cancellationToken = default)
    {
        using var client = new TcpClient();
        await client.ConnectAsync(normalizedDomain, port, cancellationToken);

        using var sslStream = new SslStream(client.GetStream(), false, static (_, _, _, _) => true);
        await sslStream.AuthenticateAsClientAsync(
            new SslClientAuthenticationOptions { TargetHost = normalizedDomain },
            cancellationToken);

        var cert = new X509Certificate2(sslStream.RemoteCertificate!);
        var now = DateTimeOffset.UtcNow;

        return new SslCertificateInfoDto
        {
            Host = normalizedDomain,
            Port = port,
            Subject = cert.Subject,
            Issuer = cert.Issuer,
            NotBefore = cert.NotBefore.ToUniversalTime(),
            NotAfter = cert.NotAfter.ToUniversalTime(),
            Thumbprint = cert.Thumbprint,
            IsValidNow = now >= cert.NotBefore && now <= cert.NotAfter
        };
    }
}
