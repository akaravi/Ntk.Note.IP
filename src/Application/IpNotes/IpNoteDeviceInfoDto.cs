namespace Ntk.Note.IP.Application.IpNotes;

public class IpNoteDeviceInfoDto
{
    public string Browser { get; init; } = string.Empty;

    public string Os { get; init; } = string.Empty;

    public string DeviceType { get; init; } = string.Empty;

    public string Language { get; init; } = string.Empty;

    public string Label { get; init; } = string.Empty;

    public string? UserAgent { get; init; }
}
