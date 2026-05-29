namespace Ntk.Note.IP.Application.Common.Models;

public sealed record PushMessage(
    string DeviceToken,
    string Title,
    string Body,
    IReadOnlyDictionary<string, string>? Data = null);
