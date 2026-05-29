namespace Ntk.Note.IP.Application.IpLookup;

public class MonitorMyIpResultDto
{
    public string Address { get; set; } = string.Empty;

    public bool IpChanged { get; set; }

    public string? PreviousAddress { get; set; }
}
