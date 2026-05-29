namespace Ntk.Note.IP.Application.IpTools;

public class SubnetInfoDto
{
    public string Cidr { get; init; } = string.Empty;

    public string NetworkAddress { get; init; } = string.Empty;

    public string BroadcastAddress { get; init; } = string.Empty;

    public string FirstHost { get; init; } = string.Empty;

    public string LastHost { get; init; } = string.Empty;

    public int PrefixLength { get; init; }

    public long UsableHosts { get; init; }
}
