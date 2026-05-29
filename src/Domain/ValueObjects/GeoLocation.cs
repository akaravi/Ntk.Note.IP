namespace Ntk.Note.IP.Domain.ValueObjects;

public sealed class GeoLocation : ValueObject
{
    public double? Latitude { get; init; }

    public double? Longitude { get; init; }

    public string? CountryCode { get; init; }

    public string? Region { get; init; }

    public string? City { get; init; }

    public static GeoLocation Create(
        double? latitude,
        double? longitude,
        string? countryCode = null,
        string? region = null,
        string? city = null)
    {
        if (latitude is < -90 or > 90)
        {
            throw new ArgumentOutOfRangeException(nameof(latitude));
        }

        if (longitude is < -180 or > 180)
        {
            throw new ArgumentOutOfRangeException(nameof(longitude));
        }

        return new GeoLocation
        {
            Latitude = latitude,
            Longitude = longitude,
            CountryCode = countryCode,
            Region = region,
            City = city
        };
    }

    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Latitude ?? 0;
        yield return Longitude ?? 0;
        yield return CountryCode ?? string.Empty;
        yield return Region ?? string.Empty;
        yield return City ?? string.Empty;
    }
}
