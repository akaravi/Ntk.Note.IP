using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Application.IpNotes;

public class IpNoteDto
{
    public int Id { get; init; }

    public string Address { get; init; } = string.Empty;

    public string? Title { get; init; }

    public string? Body { get; init; }

    public string? Tags { get; init; }

    public DateTimeOffset Created { get; init; }

    public DateTimeOffset LastModified { get; init; }

    public DateTimeOffset? NotedAtClient { get; init; }

    public string? ClientTimezone { get; init; }

    public string? LocalIpAddress { get; init; }

    public string? CountryCode { get; init; }

    public string? Region { get; init; }

    public string? City { get; init; }

    public string? Isp { get; init; }

    public string? Asn { get; init; }

    public string? DeviceLabel { get; init; }

    public IpNoteDeviceInfoDto? DeviceInfo { get; init; }

    public IpDetailsDto? IpSnapshot { get; init; }
}
