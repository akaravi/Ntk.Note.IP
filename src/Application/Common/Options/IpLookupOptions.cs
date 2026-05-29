namespace Ntk.Note.IP.Application.Common.Options;

public class IpLookupOptions
{
    public const string SectionName = "IpLookup";

    /// <summary>Fake (dev/test), IpApi (http://ip-api.com), or IpWhoIs (https://ipwho.is).</summary>
    public string Provider { get; set; } = "Fake";
}
