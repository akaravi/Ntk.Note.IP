namespace Ntk.Note.IP.Application.Common.Options;

public class CacheOptions
{
    public const string SectionName = "Cache";

    public int IpLookupMinutes { get; set; } = 15;

    public int DnsResolveMinutes { get; set; } = 5;

    /// <summary>Redis key prefix when distributed cache is configured.</summary>
    public string RedisInstanceName { get; set; } = "ipnote:";
}
