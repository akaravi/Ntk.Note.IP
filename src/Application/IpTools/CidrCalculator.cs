using System.Net;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpTools;

public static class CidrCalculator
{
    public static SubnetInfoDto Calculate(string cidr)
    {
        var parts = cidr.Trim().Split('/');
        if (parts.Length != 2 || !int.TryParse(parts[1], out var prefix) || prefix is < 0 or > 32)
        {
            throw new ArgumentException("CIDR must be in the form IPv4/prefix (0-32).", nameof(cidr));
        }

        if (!IpAddress.TryParse(parts[0], out var ip) || ip is null || !ip.IsIPv4)
        {
            throw new ArgumentException("Only IPv4 CIDR is supported in this version.", nameof(cidr));
        }

        if (!IPAddress.TryParse(ip.Value, out var address))
        {
            throw new ArgumentException("Invalid IPv4 address.", nameof(cidr));
        }

        var ipUInt = ip.ToUInt32() ?? throw new InvalidOperationException("Invalid IPv4.");
        var mask = prefix == 0 ? 0u : uint.MaxValue << (32 - prefix);
        var network = ipUInt & mask;
        var broadcast = network | ~mask;

        var firstHost = prefix >= 31 ? network : network + 1;
        var lastHost = prefix >= 31 ? broadcast : broadcast - 1;
        var usable = prefix >= 31 ? (prefix == 31 ? 2L : 1L) : (1L << (32 - prefix)) - 2;

        var networkIp = IpAddress.FromUInt32(network)?.Value ?? ip.Value;
        var broadcastIp = IpAddress.FromUInt32(broadcast)?.Value ?? ip.Value;
        var firstIp = IpAddress.FromUInt32(firstHost)?.Value ?? networkIp;
        var lastIp = IpAddress.FromUInt32(lastHost)?.Value ?? broadcastIp;

        return new SubnetInfoDto
        {
            Cidr = $"{networkIp}/{prefix}",
            NetworkAddress = networkIp,
            BroadcastAddress = broadcastIp,
            FirstHost = firstIp,
            LastHost = lastIp,
            PrefixLength = prefix,
            UsableHosts = Math.Max(usable, 0)
        };
    }
}
