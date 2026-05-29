namespace Ntk.Note.IP.Application.Common.Options;

public class OutboxOptions
{
    public const string SectionName = "Outbox";

    public bool Enabled { get; set; } = true;

    public int BatchSize { get; set; } = 20;
}
