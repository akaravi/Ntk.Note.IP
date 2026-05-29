namespace Ntk.Note.IP.Application.Common.Interfaces;

/// <summary>
/// Sends push notifications to all registered devices for a user.
/// </summary>
public interface IUserPushNotificationService
{
    Task SendToUserAsync(
        string userId,
        string title,
        string body,
        IReadOnlyDictionary<string, string>? data = null,
        CancellationToken cancellationToken = default);
}
