namespace Ntk.Note.IP.Application.Common.Options;

public class GeoIpOptions
{
    public const string SectionName = "GeoIp";

    /// <summary>Fake (dev/tests), Mmdb, or MaxMind (offline file when available).</summary>
    public string Provider { get; set; } = "Fake";

    public string? MmdbPath { get; set; }
}
