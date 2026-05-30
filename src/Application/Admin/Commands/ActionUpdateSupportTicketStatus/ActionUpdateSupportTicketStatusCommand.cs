using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;
using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionUpdateSupportTicketStatus;

[Authorize(Roles = Roles.Administrator)]
public record ActionUpdateSupportTicketStatusCommand(int Id, SupportTicketStatus Status) : IRequest;

public class ActionUpdateSupportTicketStatusCommandHandler
    : IRequestHandler<ActionUpdateSupportTicketStatusCommand>
{
    private readonly IApplicationDbContext _context;

    public ActionUpdateSupportTicketStatusCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task Handle(ActionUpdateSupportTicketStatusCommand request, CancellationToken cancellationToken)
    {
        var ticket = await _context.SupportTickets
            .FirstOrDefaultAsync(t => t.Id == request.Id, cancellationToken);

        Guard.Against.NotFound(request.Id, ticket);

        ticket!.Status = request.Status;
        await _context.SaveChangesAsync(cancellationToken);
    }
}
