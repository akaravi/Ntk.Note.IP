using System.Text.Json;
using System.Text.Json.Serialization;
using Ntk.Note.IP.Domain.Common;
using Ntk.Note.IP.Domain.Events;

namespace Ntk.Note.IP.Infrastructure.Outbox;

public static class OutboxDomainEventSerializer
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web)
    {
        ReferenceHandler = ReferenceHandler.IgnoreCycles,
        WriteIndented = false
    };

    private static readonly Dictionary<string, Type> KnownEventTypes =
        new(StringComparer.Ordinal)
        {
            [typeof(IpChangedEvent).FullName!] = typeof(IpChangedEvent),
            [typeof(NewConnectionDetectedEvent).FullName!] = typeof(NewConnectionDetectedEvent)
        };

    public static (string Type, string Content) Serialize(BaseEvent domainEvent)
    {
        var typeName = domainEvent.GetType().FullName
                       ?? throw new InvalidOperationException("Domain event type has no full name.");
        var content = JsonSerializer.Serialize(domainEvent, domainEvent.GetType(), JsonOptions);
        return (typeName, content);
    }

    public static BaseEvent Deserialize(string typeName, string content)
    {
        if (!KnownEventTypes.TryGetValue(typeName, out var eventType))
        {
            throw new NotSupportedException($"Unknown outbox event type: {typeName}");
        }

        var domainEvent = JsonSerializer.Deserialize(content, eventType, JsonOptions) as BaseEvent;
        return domainEvent ?? throw new InvalidOperationException($"Failed to deserialize outbox event {typeName}.");
    }
}
