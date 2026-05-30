using System.Net;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Application.Contact;
using Ntk.Note.IP.Domain.Entities;
using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Application.Contact.Commands.AddContactSubmission;

public record AddContactSubmissionCommand : IRequest<ContactSubmissionResultDto>
{
    public string Name { get; init; } = string.Empty;

    public string Email { get; init; } = string.Empty;

    public string Subject { get; init; } = string.Empty;

    public string Message { get; init; } = string.Empty;
}

public class AddContactSubmissionCommandValidator : AbstractValidator<AddContactSubmissionCommand>
{
    public AddContactSubmissionCommandValidator()
    {
        RuleFor(v => v.Name)
            .NotEmpty()
            .MaximumLength(200);

        RuleFor(v => v.Email)
            .NotEmpty()
            .EmailAddress()
            .MaximumLength(256);

        RuleFor(v => v.Subject)
            .NotEmpty()
            .MaximumLength(200);

        RuleFor(v => v.Message)
            .NotEmpty()
            .MaximumLength(4000);
    }
}

public class AddContactSubmissionCommandHandler
    : IRequestHandler<AddContactSubmissionCommand, ContactSubmissionResultDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IEmailSender _emailSender;
    private readonly IUser _user;
    private readonly SiteOptions _site;
    private readonly ILogger<AddContactSubmissionCommandHandler> _logger;

    public AddContactSubmissionCommandHandler(
        IApplicationDbContext context,
        IEmailSender emailSender,
        IUser user,
        IOptions<SiteOptions> site,
        ILogger<AddContactSubmissionCommandHandler> logger)
    {
        _context = context;
        _emailSender = emailSender;
        _user = user;
        _site = site.Value;
        _logger = logger;
    }

    public async Task<ContactSubmissionResultDto> Handle(
        AddContactSubmissionCommand request,
        CancellationToken cancellationToken)
    {
        var ticket = new SupportTicket
        {
            Name = request.Name.Trim(),
            Email = request.Email.Trim(),
            Subject = request.Subject.Trim(),
            Message = request.Message.Trim(),
            Status = SupportTicketStatus.Open,
            UserId = _user.Id,
        };

        _context.SupportTickets.Add(ticket);
        await _context.SaveChangesAsync(cancellationToken);

        var destination = _site.ContactToEmail?.Trim();
        if (string.IsNullOrEmpty(destination))
        {
            ticket.EmailSent = false;
            ticket.EmailError = "Site:ContactToEmail is not configured.";
            await _context.SaveChangesAsync(cancellationToken);

            return new ContactSubmissionResultDto
            {
                TicketId = ticket.Id,
                EmailSent = false,
            };
        }

        try
        {
            var plainBody =
                $"Ticket #{ticket.Id}\n" +
                $"Name: {ticket.Name}\n" +
                $"Email: {ticket.Email}\n" +
                $"UserId: {ticket.UserId ?? "(guest)"}\n\n" +
                ticket.Message;

            var htmlBody =
                $"<p><strong>Ticket #{ticket.Id}</strong></p>" +
                $"<p><strong>Name:</strong> {WebUtility.HtmlEncode(ticket.Name)}<br/>" +
                $"<strong>Email:</strong> {WebUtility.HtmlEncode(ticket.Email)}<br/>" +
                $"<strong>UserId:</strong> {WebUtility.HtmlEncode(ticket.UserId ?? "(guest)")}</p>" +
                $"<p>{WebUtility.HtmlEncode(ticket.Message).Replace("\n", "<br/>", StringComparison.Ordinal)}</p>";

            await _emailSender.SendAsync(
                destination,
                $"[IPNote #{ticket.Id}] {ticket.Subject}",
                plainBody,
                htmlBody,
                cancellationToken);

            ticket.EmailSent = true;
            ticket.EmailError = null;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to send contact email for ticket {TicketId}", ticket.Id);
            ticket.EmailSent = false;
            ticket.EmailError = ex.Message.Length > 512 ? ex.Message[..512] : ex.Message;
        }

        await _context.SaveChangesAsync(cancellationToken);

        return new ContactSubmissionResultDto
        {
            TicketId = ticket.Id,
            EmailSent = ticket.EmailSent,
        };
    }
}
