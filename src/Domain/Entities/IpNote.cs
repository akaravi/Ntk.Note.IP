namespace Ntk.Note.IP.Domain.Entities;

/// <summary>
/// User note attached to an IP address (IPNote.ir core aggregate).
/// </summary>
public class IpNote : BaseAuditableEntity
{
    public string Address { get; set; } = string.Empty;

    public string? Title { get; set; }

    public string? Body { get; set; }

    public string? Tags { get; set; }

    /// <summary>Client-reported capture time (timezone-aware).</summary>
    public DateTimeOffset? NotedAtClient { get; set; }

    public string? ClientTimezone { get; set; }

    public string? LocalIpAddress { get; set; }

    public string? CountryCode { get; set; }

    public string? Region { get; set; }

    public string? City { get; set; }

    public string? Isp { get; set; }

    public string? Asn { get; set; }

    /// <summary>Short device label for list views (e.g. Chrome · Windows).</summary>
    public string? DeviceLabel { get; set; }

    /// <summary>Full device info JSON captured at note time.</summary>
    public string? DeviceInfoJson { get; set; }

    /// <summary>Full IP lookup snapshot JSON (geo, ASN, ISP, etc.).</summary>
    public string? IpSnapshotJson { get; set; }

    public bool IsSoftDeleted { get; set; }
}
