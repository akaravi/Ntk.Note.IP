namespace Ntk.Note.IP.Application.IpLookup;

public class IpLookupResultDto
{
    public string Address { get; init; } = string.Empty;

    public string? CountryCode { get; init; }

    public string? Country { get; init; }

    public string? Region { get; init; }

    public string? City { get; init; }

    public string? Asn { get; init; }

    public string? Isp { get; init; }

    public double? Latitude { get; init; }

    public double? Longitude { get; init; }

    public string? Timezone { get; init; }

    public bool? Proxy { get; init; }

    public bool? Hosting { get; init; }

    public bool? Mobile { get; init; }

    public bool? Tor { get; init; }

    public string? ProviderPayload { get; init; }
}
