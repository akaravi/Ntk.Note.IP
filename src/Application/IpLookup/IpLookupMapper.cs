using System.Text.RegularExpressions;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup;

public static partial class IpLookupMapper
{
    public static GeoLocationDto ToGeoLocation(IpLookupResultDto result) =>
        new()
        {
            Latitude = result.Latitude,
            Longitude = result.Longitude,
            CountryCode = result.CountryCode,
            Country = result.Country,
            Region = result.Region,
            City = result.City,
            Timezone = result.Timezone
        };

    public static AsnInfoDto ToAsnInfo(IpLookupResultDto result) => ParseAsn(result.Asn);

    public static IpDetailsDto ToDetails(
        IpAddress ip,
        IpLookupResultDto lookup,
        string? reverseDns) =>
        new()
        {
            Address = ip.Value,
            Scope = ip.GetScope(),
            IsIPv6 = ip.IsIPv6,
            Geo = ToGeoLocation(lookup),
            Asn = ToAsnInfo(lookup),
            Isp = lookup.Isp,
            ReverseDns = reverseDns
        };

    public static AsnInfoDto ParseAsn(string? asnRaw)
    {
        if (string.IsNullOrWhiteSpace(asnRaw))
        {
            return new AsnInfoDto();
        }

        var match = AsnPattern().Match(asnRaw.Trim());
        if (!match.Success)
        {
            return new AsnInfoDto { Organization = asnRaw.Trim() };
        }

        return new AsnInfoDto
        {
            Number = match.Groups[1].Value,
            Organization = match.Groups[2].Value.Trim()
        };
    }

    [GeneratedRegex(@"^AS(\d+)\s*(.*)$", RegexOptions.IgnoreCase | RegexOptions.CultureInvariant)]
    private static partial Regex AsnPattern();
}
