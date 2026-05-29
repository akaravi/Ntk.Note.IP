using Microsoft.EntityFrameworkCore;

using Microsoft.Extensions.DependencyInjection;

using Ntk.Note.IP.Application.Common.Interfaces;

using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

using Ntk.Note.IP.Domain.Entities;

using Ntk.Note.IP.Domain.Events;

using Ntk.Note.IP.Infrastructure.Data;

using Ntk.Note.IP.Infrastructure.Outbox;

using NUnit.Framework;

using Shouldly;



namespace Ntk.Note.IP.Application.FunctionalTests.Outbox;



public class OutboxDispatchTests : TestBase

{

    [Test]

    public async Task ShouldProcessEnqueuedIpChangedEvent()

    {

        var (type, content) = OutboxDomainEventSerializer.Serialize(

            new IpChangedEvent("203.0.113.1", "203.0.113.25"));



        using (var enqueueScope = FunctionalTestSetup.ScopeFactory.CreateScope())

        {

            var context = enqueueScope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

            context.OutboxMessages.Add(new OutboxMessage

            {

                Id = Guid.NewGuid(),

                Type = type,

                Content = content,

                OccurredOn = DateTimeOffset.UtcNow

            });

            await context.SaveChangesAsync();

        }



        using var processScope = FunctionalTestSetup.ScopeFactory.CreateScope();

        var processor = processScope.ServiceProvider.GetRequiredService<IOutboxProcessor>();

        var processed = await processor.ProcessPendingAsync();

        processed.ShouldBeGreaterThan(0);



        using var verifyScope = FunctionalTestSetup.ScopeFactory.CreateScope();

        var verifyContext = verifyScope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

        var remaining = await verifyContext.OutboxMessages.CountAsync(m => m.ProcessedOn == null);

        remaining.ShouldBe(0);

    }

}


