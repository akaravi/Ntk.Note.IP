using System.Text.Json;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Application.IpNotes;

internal static class IpNoteSnapshotJson
{
    private static readonly JsonSerializerOptions Options = new()
    {
        PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
        WriteIndented = false
    };

    public static string? SerializeDevice(IpNoteDeviceInfoDto? device) =>
        device == null ? null : JsonSerializer.Serialize(device, Options);

    public static string? SerializeIpSnapshot(IpDetailsDto? snapshot) =>
        snapshot == null ? null : JsonSerializer.Serialize(snapshot, Options);

    public static IpNoteDeviceInfoDto? DeserializeDevice(string? json) =>
        string.IsNullOrWhiteSpace(json)
            ? null
            : JsonSerializer.Deserialize<IpNoteDeviceInfoDto>(json, Options);

    public static IpDetailsDto? DeserializeIpSnapshot(string? json) =>
        string.IsNullOrWhiteSpace(json)
            ? null
            : JsonSerializer.Deserialize<IpDetailsDto>(json, Options);
}
