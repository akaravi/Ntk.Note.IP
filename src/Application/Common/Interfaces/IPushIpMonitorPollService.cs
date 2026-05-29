namespace Ntk.Note.IP.Application.Common.Interfaces;

/// <summary>
/// Asks mobile clients (via FCM data push) to report their public IP when the last snapshot is stale.
/// </summary>
public interface IPushIpMonitorPollService
{
    Task<int> RequestStaleUserPollsAsync(CancellationToken cancellationToken = default);
}
