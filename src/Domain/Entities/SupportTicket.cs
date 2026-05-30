using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Domain.Entities;

/// <summary>
/// Contact form submission stored for admin ticketing.
/// </summary>
public class SupportTicket : BaseAuditableEntity
{
    public string Name { get; set; } = string.Empty;

    public string Email { get; set; } = string.Empty;

    public string Subject { get; set; } = string.Empty;

    public string Message { get; set; } = string.Empty;

    public SupportTicketStatus Status { get; set; } = SupportTicketStatus.Open;

    public bool EmailSent { get; set; }

    public string? EmailError { get; set; }

    public string? UserId { get; set; }
}
