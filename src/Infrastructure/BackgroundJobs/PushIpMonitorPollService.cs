using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.BackgroundJobs;

public sealed class PushIpMonitorPollService(
    IApplicationDbContext context,
    IUserPushNotificationService push,
    IOptions<PushOptions> options,
    ILogger<PushIpMonitorPollService> logger) : IPushIpMonitorPollService
{
    public const string MonitorIpDataType = "monitor_ip";

    public async Task<int> RequestStaleUserPollsAsync(CancellationToken cancellationToken = default)
    {
        var pushOptions = options.Value;
        if (!pushOptions.Enabled || !pushOptions.IpMonitorPollJobEnabled)
        {
            return 0;
        }

        var cutoff = DateTimeOffset.UtcNow.AddMinutes(-pushOptions.IpMonitorPollIntervalMinutes);

        var userIds = await context.PushDeviceRegistrations
            .AsNoTracking()
            .Where(p => p.CreatedBy != null)
            .Select(p => p.CreatedBy!)
            .Distinct()
            .ToListAsync(cancellationToken);

        var sent = 0;
        foreach (var userId in userIds)
        {
            var snapshot = await context.UserPublicIpSnapshots
                .AsNoTracking()
                .FirstOrDefaultAsync(s => s.UserId == userId, cancellationToken);

            if (snapshot is not null && snapshot.UpdatedAt >= cutoff)
            {
                continue;
            }

            await push.SendToUserAsync(
                userId,
                title: string.Empty,
                body: string.Empty,
                data: new Dictionary<string, string>
                {
                    ["type"] = MonitorIpDataType,
                },
                cancellationToken);

            sent++;
        }

        if (sent > 0)
        {
            logger.LogInformation("Requested IP monitor poll for {Count} user(s).", sent);
        }

        return sent;
    }
}
