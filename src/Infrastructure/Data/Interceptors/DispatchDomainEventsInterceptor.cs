using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Domain.Common;
using Ntk.Note.IP.Domain.Entities;
using Ntk.Note.IP.Infrastructure.Outbox;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.Options;

namespace Ntk.Note.IP.Infrastructure.Data.Interceptors;

public class DispatchDomainEventsInterceptor : SaveChangesInterceptor
{
    private readonly IMediator _mediator;
    private readonly IOptions<OutboxOptions> _outboxOptions;

    public DispatchDomainEventsInterceptor(IMediator mediator, IOptions<OutboxOptions> outboxOptions)
    {
        _mediator = mediator;
        _outboxOptions = outboxOptions;
    }

    public override InterceptionResult<int> SavingChanges(DbContextEventData eventData, InterceptionResult<int> result)
    {
        DispatchDomainEvents(eventData.Context).GetAwaiter().GetResult();

        return base.SavingChanges(eventData, result);

    }

    public override async ValueTask<InterceptionResult<int>> SavingChangesAsync(DbContextEventData eventData, InterceptionResult<int> result, CancellationToken cancellationToken = default)
    {
        await DispatchDomainEvents(eventData.Context);

        return await base.SavingChangesAsync(eventData, result, cancellationToken);
    }

    public async Task DispatchDomainEvents(DbContext? context)
    {
        if (context == null) return;

        var entities = context.ChangeTracker
            .Entries<BaseEntity>()
            .Where(e => e.Entity.DomainEvents.Any())
            .Select(e => e.Entity);

        var domainEvents = entities
            .SelectMany(e => e.DomainEvents)
            .ToList();

        entities.ToList().ForEach(e => e.ClearDomainEvents());

        if (!_outboxOptions.Value.Enabled)
        {
            foreach (var domainEvent in domainEvents)
            {
                await _mediator.Publish(domainEvent);
            }

            return;
        }

        if (context is not ApplicationDbContext dbContext)
        {
            foreach (var domainEvent in domainEvents)
            {
                await _mediator.Publish(domainEvent);
            }

            return;
        }

        foreach (var domainEvent in domainEvents)
        {
            var (type, content) = OutboxDomainEventSerializer.Serialize(domainEvent);
            dbContext.OutboxMessages.Add(new OutboxMessage
            {
                Id = Guid.NewGuid(),
                Type = type,
                Content = content,
                OccurredOn = DateTimeOffset.UtcNow
            });
        }
    }
}
