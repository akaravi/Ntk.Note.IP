namespace Ntk.Note.IP.Application.GeoIp;

public class GeoIpLookupResult
{
    public string Address { get; init; } = string.Empty;

    public string? CountryCode { get; init; }

    public string? Country { get; init; }

    public string? Region { get; init; }

    public string? City { get; init; }

    public double? Latitude { get; init; }

    public double? Longitude { get; init; }

    public string? Timezone { get; init; }

    public string Source { get; init; } = "offline";
}
