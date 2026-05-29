using Microsoft.Extensions.Logging;
using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Infrastructure.BackgroundJobs;

public sealed class ProcessOutboxJob(IOutboxProcessor outboxProcessor, ILogger<ProcessOutboxJob> logger)
{
    public async Task ExecuteAsync(CancellationToken cancellationToken = default)
    {
        var count = await outboxProcessor.ProcessPendingAsync(cancellationToken);
        if (count > 0)
        {
            logger.LogInformation("Processed {Count} outbox message(s).", count);
        }
    }
}
