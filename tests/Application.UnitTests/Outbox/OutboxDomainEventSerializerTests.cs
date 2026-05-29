using Ntk.Note.IP.Domain.Events;
using Ntk.Note.IP.Infrastructure.Outbox;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.Outbox;

public class OutboxDomainEventSerializerTests
{
    [Test]
    public void ShouldRoundTripIpChangedEvent()
    {
        var original = new IpChangedEvent("1.1.1.1", "8.8.8.8");
        var (type, content) = OutboxDomainEventSerializer.Serialize(original);
        var restored = OutboxDomainEventSerializer.Deserialize(type, content);

        restored.ShouldBeOfType<IpChangedEvent>();
        var ipChanged = (IpChangedEvent)restored;
        ipChanged.PreviousAddress.ShouldBe("1.1.1.1");
        ipChanged.CurrentAddress.ShouldBe("8.8.8.8");
    }
}
