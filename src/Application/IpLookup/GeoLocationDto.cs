namespace Ntk.Note.IP.Application.IpLookup;

public class GeoLocationDto
{
    public double? Latitude { get; init; }

    public double? Longitude { get; init; }

    public string? CountryCode { get; init; }

    public string? Country { get; init; }

    public string? Region { get; init; }

    public string? City { get; init; }

    public string? Timezone { get; init; }
}
