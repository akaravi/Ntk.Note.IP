using FluentValidation.Results;
using Microsoft.EntityFrameworkCore;
using AppValidationException = Ntk.Note.IP.Application.Common.Exceptions.ValidationException;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Domain.Entities;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup.Commands.ActionMonitorMyIp;

[Authorize]
public record ActionMonitorMyIpCommand : IRequest<MonitorMyIpResultDto>;

public class ActionMonitorMyIpCommandHandler : IRequestHandler<ActionMonitorMyIpCommand, MonitorMyIpResultDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IClientIpResolver _clientIpResolver;
    private readonly IUser _user;
    private readonly IUserPushNotificationService _push;

    public ActionMonitorMyIpCommandHandler(
        IApplicationDbContext context,
        IClientIpResolver clientIpResolver,
        IUser user,
        IUserPushNotificationService push)
    {
        _context = context;
        _clientIpResolver = clientIpResolver;
        _user = user;
        _push = push;
    }

    public async Task<MonitorMyIpResultDto> Handle(
        ActionMonitorMyIpCommand request,
        CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);
        var rawIp = _clientIpResolver.GetClientIpAddress();

        if (string.IsNullOrWhiteSpace(rawIp) || !IpAddress.TryParse(rawIp, out var ip))
        {
            throw new AppValidationException([
                new ValidationFailure("ClientIp", "Unable to resolve a valid client IP address."),
            ]);
        }

        var address = ip!.Value;
        var snapshot = await _context.UserPublicIpSnapshots
            .FirstOrDefaultAsync(s => s.UserId == userId, cancellationToken);

        var previous = snapshot?.Address;
        var changed = snapshot is not null &&
                      !string.Equals(previous, address, StringComparison.OrdinalIgnoreCase);

        if (changed)
        {
            await _push.SendToUserAsync(
                userId,
                title: "IPNote.ir",
                body: $"Public IP changed to {address}",
                data: new Dictionary<string, string>
                {
                    ["type"] = "ip_changed",
                    ["address"] = address,
                    ["previousAddress"] = previous ?? string.Empty,
                },
                cancellationToken);
        }

        if (snapshot is null)
        {
            _context.UserPublicIpSnapshots.Add(new UserPublicIpSnapshot
            {
                UserId = userId,
                Address = address,
                UpdatedAt = DateTimeOffset.UtcNow,
            });
        }
        else
        {
            snapshot.Address = address;
            snapshot.UpdatedAt = DateTimeOffset.UtcNow;
        }

        await _context.SaveChangesAsync(cancellationToken);

        return new MonitorMyIpResultDto
        {
            Address = address,
            IpChanged = changed,
            PreviousAddress = previous,
        };
    }
}
