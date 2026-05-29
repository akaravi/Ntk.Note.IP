namespace Ntk.Note.IP.Application.IpTools;

public class PrivacyFlagsDto
{
    public string Address { get; init; } = string.Empty;

    public bool Proxy { get; init; }

    public bool Hosting { get; init; }

    public bool Mobile { get; init; }

    public bool Tor { get; init; }
}
