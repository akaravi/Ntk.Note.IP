namespace Ntk.Note.IP.Application.Dns;

public class DnsResolveResultDto
{
    public string Domain { get; init; } = string.Empty;

    public IReadOnlyList<DnsRecordDto> Records { get; init; } = [];
}
