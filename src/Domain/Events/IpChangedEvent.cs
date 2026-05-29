namespace Ntk.Note.IP.Domain.Events;

public class IpChangedEvent(string previousAddress, string currentAddress) : BaseEvent
{
    public string PreviousAddress { get; } = previousAddress;

    public string CurrentAddress { get; } = currentAddress;
}
