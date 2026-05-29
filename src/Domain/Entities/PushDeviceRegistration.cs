namespace Ntk.Note.IP.Domain.Entities;

/// <summary>
/// FCM/APNs device token registered for push notifications (per user).
/// </summary>
public class PushDeviceRegistration : BaseAuditableEntity
{
    public string DeviceToken { get; set; } = string.Empty;

    public string Platform { get; set; } = string.Empty;
}
