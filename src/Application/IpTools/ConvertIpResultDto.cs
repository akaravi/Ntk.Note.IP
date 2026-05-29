namespace Ntk.Note.IP.Application.IpTools;

public class ConvertIpResultDto
{
    public string Address { get; init; } = string.Empty;

    public string? CompressedIPv6 { get; init; }

    public uint? UInt32 { get; init; }

    public string? Hex { get; init; }

    public bool IsIPv6 { get; init; }
}
