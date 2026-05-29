using Microsoft.EntityFrameworkCore;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;

namespace Ntk.Note.IP.Application.IpNotes.Commands.DeleteIpNote;

[Authorize]
public record DeleteIpNoteCommand(int Id) : IRequest;

public class DeleteIpNoteCommandHandler : IRequestHandler<DeleteIpNoteCommand>
{
    private readonly IApplicationDbContext _context;
    private readonly IUser _user;

    public DeleteIpNoteCommandHandler(IApplicationDbContext context, IUser user)
    {
        _context = context;
        _user = user;
    }

    public async Task Handle(DeleteIpNoteCommand request, CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);

        var entity = await _context.IpNotes
            .OwnedBy(userId)
            .FirstOrDefaultAsync(n => n.Id == request.Id, cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        entity.IsSoftDeleted = true;
        await _context.SaveChangesAsync(cancellationToken);
    }
}
