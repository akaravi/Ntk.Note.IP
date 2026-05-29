namespace Ntk.Note.IP.Application.IpLookup;

public class IpLookupRecordDto
{
    public int Id { get; init; }

    public string Address { get; init; } = string.Empty;

    public string? CountryCode { get; init; }

    public string? Region { get; init; }

    public string? City { get; init; }

    public string? Asn { get; init; }

    public string? Isp { get; init; }

    public DateTimeOffset Created { get; init; }

    public DateTimeOffset LastModified { get; init; }
}
