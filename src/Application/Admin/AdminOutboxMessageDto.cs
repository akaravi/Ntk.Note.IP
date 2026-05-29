namespace Ntk.Note.IP.Application.Admin;

public class AdminOutboxMessageDto
{
    public Guid Id { get; init; }

    public string Type { get; init; } = string.Empty;

    public DateTimeOffset OccurredOn { get; init; }

    public DateTimeOffset? ProcessedOn { get; init; }

    public string? Error { get; init; }

    public int ContentLength { get; init; }
}
