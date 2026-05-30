namespace Ntk.Note.IP.Application.Admin;

public sealed class AdminSupportTicketDto
{
    public int Id { get; init; }

    public string Name { get; init; } = string.Empty;

    public string Email { get; init; } = string.Empty;

    public string Subject { get; init; } = string.Empty;

    public string Message { get; init; } = string.Empty;

    public string Status { get; init; } = string.Empty;

    public bool EmailSent { get; init; }

    public string? EmailError { get; init; }

    public string? UserId { get; init; }

    public DateTimeOffset Created { get; init; }
}
