using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Models;

namespace Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

public sealed class TrackingPushSender : IPushSender
{
    public List<PushMessage> Sent { get; } = [];

    public Task SendAsync(PushMessage message, CancellationToken cancellationToken = default)
    {
        Sent.Add(message);
        return Task.CompletedTask;
    }
}
