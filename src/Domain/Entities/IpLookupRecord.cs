namespace Ntk.Note.IP.Domain.Entities;

/// <summary>
/// Cached or historical result of an external IP lookup (geo/ASN/provider).
/// </summary>
public class IpLookupRecord : BaseAuditableEntity
{
    public string Address { get; set; } = string.Empty;

    public string? CountryCode { get; set; }

    public string? Region { get; set; }

    public string? City { get; set; }

    public string? Asn { get; set; }

    public string? Isp { get; set; }

    /// <summary>Raw provider JSON for audit and re-parse.</summary>
    public string? ProviderPayload { get; set; }
}
