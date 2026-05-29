using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Domain.Entities;

/// <summary>
/// A single observed IP connection/session for history and analytics.
/// </summary>
public class IpRecord : BaseAuditableEntity
{
    public string Address { get; set; } = string.Empty;

    public string? UserId { get; set; }

    public string? Note { get; set; }

    public string? Tags { get; set; }

    public DeviceType DeviceType { get; set; } = DeviceType.Unknown;

    public NetworkType NetworkType { get; set; } = NetworkType.Unknown;

    public ConnectionType ConnectionType { get; set; } = ConnectionType.Unknown;

    public string? CountryCode { get; set; }

    public string? City { get; set; }

    public string? UserAgent { get; set; }

    public bool IsSoftDeleted { get; set; }
}
