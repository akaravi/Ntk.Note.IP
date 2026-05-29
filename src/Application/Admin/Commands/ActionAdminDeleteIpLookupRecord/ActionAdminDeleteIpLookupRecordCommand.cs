using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionAdminDeleteIpLookupRecord;

[Authorize(Roles = Roles.Administrator)]
public record ActionAdminDeleteIpLookupRecordCommand(int Id) : IRequest;

public class ActionAdminDeleteIpLookupRecordCommandHandler : IRequestHandler<ActionAdminDeleteIpLookupRecordCommand>
{
    private readonly IApplicationDbContext _context;

    public ActionAdminDeleteIpLookupRecordCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task Handle(ActionAdminDeleteIpLookupRecordCommand request, CancellationToken cancellationToken)
    {
        var entity = await _context.IpLookupRecords
            .FirstOrDefaultAsync(r => r.Id == request.Id, cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        _context.IpLookupRecords.Remove(entity!);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
