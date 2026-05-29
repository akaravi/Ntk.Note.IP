using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionAdminDeletePushDevice;

[Authorize(Roles = Roles.Administrator)]
public record ActionAdminDeletePushDeviceCommand(int Id) : IRequest;

public class ActionAdminDeletePushDeviceCommandHandler : IRequestHandler<ActionAdminDeletePushDeviceCommand>
{
    private readonly IApplicationDbContext _context;

    public ActionAdminDeletePushDeviceCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task Handle(ActionAdminDeletePushDeviceCommand request, CancellationToken cancellationToken)
    {
        var entity = await _context.PushDeviceRegistrations
            .FirstOrDefaultAsync(p => p.Id == request.Id, cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        _context.PushDeviceRegistrations.Remove(entity!);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
