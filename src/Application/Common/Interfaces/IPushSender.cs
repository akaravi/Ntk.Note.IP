using Ntk.Note.IP.Application.Common.Models;

namespace Ntk.Note.IP.Application.Common.Interfaces;

/// <summary>
/// Sends mobile push notifications (FCM/APNs). Default host registration uses NoOp until Firebase is configured.
/// </summary>
public interface IPushSender
{
    Task SendAsync(PushMessage message, CancellationToken cancellationToken = default);
}
