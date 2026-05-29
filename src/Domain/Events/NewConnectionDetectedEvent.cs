namespace Ntk.Note.IP.Domain.Events;

public class NewConnectionDetectedEvent(string address, string? userId) : BaseEvent
{
    public string Address { get; } = address;

    public string? UserId { get; } = userId;
}
