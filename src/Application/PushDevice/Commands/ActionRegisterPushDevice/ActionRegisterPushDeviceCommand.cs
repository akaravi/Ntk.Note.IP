using Microsoft.EntityFrameworkCore;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Application.PushDevice.Commands.ActionRegisterPushDevice;

[Authorize]
public record ActionRegisterPushDeviceCommand : IRequest
{
    public string DeviceToken { get; init; } = string.Empty;

    public string Platform { get; init; } = string.Empty;
}

public class ActionRegisterPushDeviceCommandValidator : AbstractValidator<ActionRegisterPushDeviceCommand>
{
    private static readonly string[] AllowedPlatforms = ["android", "ios"];

    public ActionRegisterPushDeviceCommandValidator()
    {
        RuleFor(v => v.DeviceToken)
            .NotEmpty()
            .MaximumLength(512);

        RuleFor(v => v.Platform)
            .NotEmpty()
            .MaximumLength(16)
            .Must(p => AllowedPlatforms.Contains(p.Trim().ToLowerInvariant()))
            .WithMessage("Platform must be android or ios.");
    }
}

public class ActionRegisterPushDeviceCommandHandler : IRequestHandler<ActionRegisterPushDeviceCommand>
{
    private readonly IApplicationDbContext _context;
    private readonly IUser _user;

    public ActionRegisterPushDeviceCommandHandler(IApplicationDbContext context, IUser user)
    {
        _context = context;
        _user = user;
    }

    public async Task Handle(ActionRegisterPushDeviceCommand request, CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);
        var token = request.DeviceToken.Trim();
        var platform = request.Platform.Trim().ToLowerInvariant();

        var existing = await _context.PushDeviceRegistrations
            .Where(p => p.CreatedBy == userId && p.DeviceToken == token)
            .FirstOrDefaultAsync(cancellationToken);

        if (existing is not null)
        {
            existing.Platform = platform;
            await _context.SaveChangesAsync(cancellationToken);
            return;
        }

        _context.PushDeviceRegistrations.Add(new PushDeviceRegistration
        {
            DeviceToken = token,
            Platform = platform,
        });

        await _context.SaveChangesAsync(cancellationToken);
    }
}
