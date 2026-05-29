namespace Ntk.Note.IP.Application.Dns;

public class DnsRecordDto
{
    public string Type { get; init; } = string.Empty;

    public string Name { get; init; } = string.Empty;

    public string Value { get; init; } = string.Empty;

    public int? Preference { get; init; }

    public int? Ttl { get; init; }
}
