using Ntk.Note.IP.Application.Admin.Queries.GetListAdminOutboxMessages;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using Ntk.Note.IP.Domain.Entities;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.FunctionalTests.Admin;

public class AdminOutboxTests : TestBase
{
    [Test]
    public async Task AdministratorShouldListOutboxMessages()
    {
        await TestApp.RunAsAdministratorAsync();

        await TestApp.AddAsync(new OutboxMessage
        {
            Id = Guid.NewGuid(),
            Type = "IpChangedEvent",
            Content = "{\"previous\":\"1.1.1.1\",\"current\":\"2.2.2.2\"}",
            OccurredOn = DateTimeOffset.UtcNow,
        });

        var list = await TestApp.SendAsync(new GetListAdminOutboxMessagesQuery());

        list.ShouldNotBeEmpty();
        list.ShouldContain(m => m.Type == "IpChangedEvent");
        list.First(m => m.Type == "IpChangedEvent").ContentLength.ShouldBeGreaterThan(0);
    }
}
