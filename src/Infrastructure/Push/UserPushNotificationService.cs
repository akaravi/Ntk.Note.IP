using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.Push;

public sealed class UserPushNotificationService(
    IApplicationDbContext context,
    IPushSender pushSender,
    IOptions<PushOptions> options,
    ILogger<UserPushNotificationService> logger) : IUserPushNotificationService
{
    public async Task SendToUserAsync(
        string userId,
        string title,
        string body,
        IReadOnlyDictionary<string, string>? data = null,
        CancellationToken cancellationToken = default)
    {
        if (!options.Value.Enabled)
        {
            return;
        }

        var tokens = await context.PushDeviceRegistrations
            .AsNoTracking()
            .Where(p => p.CreatedBy == userId)
            .Select(p => p.DeviceToken)
            .ToListAsync(cancellationToken);

        if (tokens.Count == 0)
        {
            return;
        }

        foreach (var token in tokens)
        {
            try
            {
                await pushSender.SendAsync(
                    new PushMessage(token, title, body, data),
                    cancellationToken);
            }
            catch (Exception ex)
            {
                logger.LogWarning(
                    ex,
                    "Push failed for user {UserId}, token prefix {TokenPrefix}",
                    userId,
                    token.Length > 8 ? token[..8] : token);
            }
        }
    }
}
