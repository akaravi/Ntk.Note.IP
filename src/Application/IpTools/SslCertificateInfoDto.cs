namespace Ntk.Note.IP.Application.IpTools;

public class SslCertificateInfoDto
{
    public string Host { get; init; } = string.Empty;

    public int Port { get; init; }

    public string? Subject { get; init; }

    public string? Issuer { get; init; }

    public DateTimeOffset? NotBefore { get; init; }

    public DateTimeOffset? NotAfter { get; init; }

    public string? Thumbprint { get; init; }

    public bool IsValidNow { get; init; }
}
