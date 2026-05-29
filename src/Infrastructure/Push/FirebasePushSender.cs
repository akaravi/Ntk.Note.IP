using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.Push;

public sealed class FirebasePushSender(
    IOptions<PushOptions> options,
    ILogger<FirebasePushSender> logger) : IPushSender
{
    private static readonly object InitLock = new();
    private static bool _initialized;

    public async Task SendAsync(PushMessage message, CancellationToken cancellationToken = default)
    {
        if (!EnsureInitialized())
        {
            return;
        }

        var hasNotification =
            !string.IsNullOrWhiteSpace(message.Title) ||
            !string.IsNullOrWhiteSpace(message.Body);

        var fcmMessage = new Message
        {
            Token = message.DeviceToken,
            Notification = hasNotification
                ? new Notification
                {
                    Title = message.Title,
                    Body = message.Body,
                }
                : null,
            Data = message.Data?.ToDictionary(static pair => pair.Key, static pair => pair.Value),
        };

        try
        {
            await FirebaseMessaging.DefaultInstance.SendAsync(fcmMessage, cancellationToken);
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "FCM send failed for token prefix {Prefix}",
                message.DeviceToken.Length > 8 ? message.DeviceToken[..8] : message.DeviceToken);
            throw;
        }
    }

    private bool EnsureInitialized()
    {
        if (_initialized)
        {
            return true;
        }

        lock (InitLock)
        {
            if (_initialized)
            {
                return true;
            }

            var path = options.Value.FirebaseCredentialsPath;
            if (string.IsNullOrWhiteSpace(path) || !File.Exists(path))
            {
                logger.LogWarning(
                    "Firebase push not initialized: Push:FirebaseCredentialsPath missing or file not found.");
                return false;
            }

            try
            {
                if (FirebaseApp.DefaultInstance == null)
                {
                    FirebaseApp.Create(new AppOptions
                    {
                        Credential = GoogleCredential.FromFile(path),
                    });
                }

                _initialized = true;
                return true;
            }
            catch (Exception ex)
            {
                logger.LogError(ex, "Failed to initialize Firebase Admin SDK.");
                return false;
            }
        }
    }
}
