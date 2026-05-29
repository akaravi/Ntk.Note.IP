namespace Ntk.Note.IP.Application.Common.Options;

public class IpLookupOptions
{
    public const string SectionName = "IpLookup";

    /// <summary>Fake (dev/test) or IpApi (http://ip-api.com).</summary>
    public string Provider { get; set; } = "Fake";
}
