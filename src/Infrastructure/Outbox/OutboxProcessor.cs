using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Infrastructure.Data;

namespace Ntk.Note.IP.Infrastructure.Outbox;

public sealed class OutboxProcessor(
    ApplicationDbContext context,
    IMediator mediator,
    IOptions<OutboxOptions> options,
    ILogger<OutboxProcessor> logger) : IOutboxProcessor
{
    public async Task<int> ProcessPendingAsync(CancellationToken cancellationToken = default)
    {
        var batchSize = Math.Max(1, options.Value.BatchSize);
        var pending = await context.OutboxMessages
            .Where(m => m.ProcessedOn == null)
            .OrderBy(m => m.Id)
            .Take(batchSize)
            .ToListAsync(cancellationToken);

        if (pending.Count == 0)
        {
            return 0;
        }

        var processed = 0;

        foreach (var message in pending)
        {
            try
            {
                var domainEvent = OutboxDomainEventSerializer.Deserialize(message.Type, message.Content);
                await mediator.Publish(domainEvent, cancellationToken);
                message.ProcessedOn = DateTimeOffset.UtcNow;
                message.Error = null;
                processed++;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Outbox message {OutboxId} failed", message.Id);
                message.Error = ex.Message.Length > 2000 ? ex.Message[..2000] : ex.Message;
            }
        }

        await context.SaveChangesAsync(cancellationToken);
        return processed;
    }
}
