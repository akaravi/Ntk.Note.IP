using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Application.IpLookup;

public class IpDetailsDto
{
    public string Address { get; init; } = string.Empty;

    public IpAddressScope Scope { get; init; }

    public bool IsIPv6 { get; init; }

    public GeoLocationDto Geo { get; init; } = new();

    public AsnInfoDto Asn { get; init; } = new();

    public string? Isp { get; init; }

    public string? ReverseDns { get; init; }
}
