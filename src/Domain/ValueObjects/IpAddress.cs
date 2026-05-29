using System.Net;
using System.Net.Sockets;
using Ntk.Note.IP.Domain.Enums;
using Ntk.Note.IP.Domain.Exceptions;

namespace Ntk.Note.IP.Domain.ValueObjects;

public sealed class IpAddress : ValueObject
{
    private IpAddress(string normalized, AddressFamily family)
    {
        Value = normalized;
        Family = family;
    }

    public string Value { get; }

    public AddressFamily Family { get; }

    public bool IsIPv4 => Family == AddressFamily.InterNetwork;

    public bool IsIPv6 => Family == AddressFamily.InterNetworkV6;

    public static IpAddress Parse(string input)
    {
        if (!TryParse(input, out var address) || address is null)
        {
            throw new InvalidIpAddressException(input);
        }

        return address;
    }

    public static bool TryParse(string? input, out IpAddress? address)
    {
        address = null;
        if (string.IsNullOrWhiteSpace(input))
        {
            return false;
        }

        if (!IPAddress.TryParse(input.Trim(), out var parsed))
        {
            return false;
        }

        address = new IpAddress(parsed.ToString(), parsed.AddressFamily);
        return true;
    }

    public IpAddressScope GetScope()
    {
        if (!IPAddress.TryParse(Value, out var ip))
        {
            return IpAddressScope.Reserved;
        }

        if (IPAddress.IsLoopback(ip))
        {
            return IpAddressScope.Loopback;
        }

        if (ip.AddressFamily == AddressFamily.InterNetwork)
        {
            var bytes = ip.GetAddressBytes();
            if (bytes[0] == 10)
            {
                return IpAddressScope.Private;
            }

            if (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31)
            {
                return IpAddressScope.Private;
            }

            if (bytes[0] == 192 && bytes[1] == 168)
            {
                return IpAddressScope.Private;
            }

            if (bytes[0] == 100 && bytes[1] >= 64 && bytes[1] <= 127)
            {
                return IpAddressScope.Cgnat;
            }

            if (bytes[0] == 169 && bytes[1] == 254)
            {
                return IpAddressScope.LinkLocal;
            }

            return IpAddressScope.Public;
        }

        if (ip.IsIPv6LinkLocal)
        {
            return IpAddressScope.LinkLocal;
        }

        if (ip.IsIPv6UniqueLocal)
        {
            return IpAddressScope.UniqueLocal;
        }

        return IpAddressScope.Public;
    }

    public uint? ToUInt32()
    {
        if (!IsIPv4 || !IPAddress.TryParse(Value, out var ip))
        {
            return null;
        }

        var bytes = ip.GetAddressBytes();
        return (uint)(bytes[0] << 24 | bytes[1] << 16 | bytes[2] << 8 | bytes[3]);
    }

    public static IpAddress? FromUInt32(uint value)
    {
        var bytes = new byte[]
        {
            (byte)(value >> 24),
            (byte)(value >> 16),
            (byte)(value >> 8),
            (byte)value
        };

        return TryParse(new IPAddress(bytes).ToString(), out var address) ? address : null;
    }

    public override string ToString() => Value;

    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Value;
    }
}
