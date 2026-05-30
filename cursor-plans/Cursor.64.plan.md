# Cursor Plan — Ntk.Note.IP (Post-S9 Part 64)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 64",
    "updatedAt": "2026-05-31T04:00:00+03:30",
    "previousPart": "Cursor.63.plan.md"
  },
  "Part 64": {
    "title": "Hangfire push IP monitor poll + FCM client handler",
    "goal": "Recurring job sends FCM data push (monitor_ip) to users with stale snapshots; Flutter handles message and calls ActionMonitorMyIp; fix login push registration hook"
  },
  "Result 64": {
    "summary": "PushIpMonitorPollJob (Hangfire */15); IPushIpMonitorPollService skips fresh snapshots; data-only FCM; PushIpMonitorListener on Flutter; auth login registers push + binds listener.",
    "paths": {
      "job": "src/Infrastructure/BackgroundJobs/PushIpMonitorPollJob.cs",
      "flutter": "lib/core/push/push_ip_monitor_listener.dart"
    },
    "config": {
      "Push:IpMonitorPollJobEnabled": true,
      "Push:IpMonitorPollIntervalMinutes": 60,
      "Push:IpMonitorPollCron": "*/15 * * * *"
    },
    "verification": {
      "functionalTests": "40/40",
      "flutterTest": "21/21 expected"
    },
    "deferred": [
      "FCM background isolate handler (app killed)",
      "Production Firebase credentials E2E"
    ]
  }
}
```
