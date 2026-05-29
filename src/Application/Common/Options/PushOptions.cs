namespace Ntk.Note.IP.Application.Common.Options;

public class PushOptions
{
    public const string SectionName = "Push";

    /// <summary>NoOp (default) or Firebase when server credentials are configured.</summary>
    public string Provider { get; set; } = "NoOp";

    public bool Enabled { get; set; }

    /// <summary>Path to Firebase service account JSON (FCM HTTP v1).</summary>
    public string? FirebaseCredentialsPath { get; set; }

    /// <summary>Hangfire job: send FCM data push to wake clients when snapshot is stale.</summary>
    public bool IpMonitorPollJobEnabled { get; set; } = true;

    /// <summary>Skip poll when snapshot was updated within this many minutes.</summary>
    public int IpMonitorPollIntervalMinutes { get; set; } = 60;

    /// <summary>Cron for push-ip-monitor-poll (default: every 15 minutes).</summary>
    public string IpMonitorPollCron { get; set; } = "*/15 * * * *";
}
