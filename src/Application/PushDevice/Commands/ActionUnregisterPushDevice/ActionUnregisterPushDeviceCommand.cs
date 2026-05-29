using Microsoft.EntityFrameworkCore;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpNotes;
namespace Ntk.Note.IP.Application.PushDevice.Commands.ActionUnregisterPushDevice;

[Authorize]
public record ActionUnregisterPushDeviceCommand : IRequest
{
    public string DeviceToken { get; init; } = string.Empty;
}

public class ActionUnregisterPushDeviceCommandValidator : AbstractValidator<ActionUnregisterPushDeviceCommand>
{
    public ActionUnregisterPushDeviceCommandValidator()
    {
        RuleFor(v => v.DeviceToken)
            .NotEmpty()
            .MaximumLength(512);
    }
}

public class ActionUnregisterPushDeviceCommandHandler : IRequestHandler<ActionUnregisterPushDeviceCommand>
{
    private readonly IApplicationDbContext _context;
    private readonly IUser _user;

    public ActionUnregisterPushDeviceCommandHandler(IApplicationDbContext context, IUser user)
    {
        _context = context;
        _user = user;
    }

    public async Task Handle(ActionUnregisterPushDeviceCommand request, CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);
        var token = request.DeviceToken.Trim();

        var rows = await _context.PushDeviceRegistrations
            .Where(p => p.CreatedBy == userId && p.DeviceToken == token)
            .ToListAsync(cancellationToken);

        if (rows.Count == 0)
        {
            return;
        }

        _context.PushDeviceRegistrations.RemoveRange(rows);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
