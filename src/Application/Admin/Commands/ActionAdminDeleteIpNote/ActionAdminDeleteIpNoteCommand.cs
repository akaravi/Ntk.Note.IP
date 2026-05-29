using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionAdminDeleteIpNote;

[Authorize(Roles = Roles.Administrator)]
public record ActionAdminDeleteIpNoteCommand(int Id) : IRequest;

public class ActionAdminDeleteIpNoteCommandHandler : IRequestHandler<ActionAdminDeleteIpNoteCommand>
{
    private readonly IApplicationDbContext _context;

    public ActionAdminDeleteIpNoteCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task Handle(ActionAdminDeleteIpNoteCommand request, CancellationToken cancellationToken)
    {
        var entity = await _context.IpNotes
            .FirstOrDefaultAsync(n => n.Id == request.Id, cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        _context.IpNotes.Remove(entity!);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
