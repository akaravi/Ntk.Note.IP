using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.Push;

public sealed class NoOpPushSender(
    IOptions<PushOptions> options,
    ILogger<NoOpPushSender> logger) : IPushSender
{
    public Task SendAsync(PushMessage message, CancellationToken cancellationToken = default)
    {
        if (options.Value.Enabled)
        {
            logger.LogDebug(
                "Push skipped (NoOp provider). Token prefix {TokenPrefix}, title {Title}",
                message.DeviceToken.Length > 8
                    ? message.DeviceToken[..8]
                    : message.DeviceToken,
                message.Title);
        }

        return Task.CompletedTask;
    }
}
