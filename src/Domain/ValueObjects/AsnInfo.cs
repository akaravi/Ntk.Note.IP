namespace Ntk.Note.IP.Domain.ValueObjects;

public sealed class AsnInfo : ValueObject
{
    public string? Number { get; init; }

    public string? Organization { get; init; }

    public string? Domain { get; init; }

    public static AsnInfo Create(string? number, string? organization, string? domain = null) =>
        new() { Number = number, Organization = organization, Domain = domain };

    protected override IEnumerable<object> GetEqualityComponents()
    {
        yield return Number ?? string.Empty;
        yield return Organization ?? string.Empty;
        yield return Domain ?? string.Empty;
    }
}
