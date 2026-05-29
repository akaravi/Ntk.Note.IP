namespace Ntk.Note.IP.Application.Common.Options;

public class DnsOptions
{
    public const string SectionName = "Dns";

    /// <summary>Fake (dev/test) or DnsClient (live resolver).</summary>
    public string Provider { get; set; } = "Fake";
}
