using Microsoft.Extensions.Logging;
using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Infrastructure.BackgroundJobs;

public sealed class PushIpMonitorPollJob(
    IPushIpMonitorPollService pollService,
    ILogger<PushIpMonitorPollJob> logger)
{
    public async Task ExecuteAsync(CancellationToken cancellationToken = default)
    {
        var count = await pollService.RequestStaleUserPollsAsync(cancellationToken);
        if (count > 0)
        {
            logger.LogInformation("Push IP monitor poll job sent {Count} request(s).", count);
        }
    }
}
