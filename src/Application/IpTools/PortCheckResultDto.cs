namespace Ntk.Note.IP.Application.IpTools;

public class PortCheckResultDto
{
    public string Host { get; init; } = string.Empty;

    public int Port { get; init; }

    public bool IsOpen { get; init; }

    public int? LatencyMs { get; init; }

    public string? ErrorMessage { get; init; }
}
