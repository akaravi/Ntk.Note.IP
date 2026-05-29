using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Application.IpLookup;

public class MyIpDto
{
    public string Address { get; init; } = string.Empty;

    public IpAddressScope Scope { get; init; }

    public bool IsIPv6 { get; init; }
}
