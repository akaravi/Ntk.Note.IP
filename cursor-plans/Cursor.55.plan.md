# Cursor Plan — Ntk.Note.IP (Post-S9 Part 55)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 55",
    "updatedAt": "2026-05-30T19:00:00+03:30",
    "previousPart": "Cursor.54.plan.md"
  },
  "Part 55": {
    "title": "Background public IP monitor (S7-044)",
    "goal": "workmanager periodic task; GetMyIp in background; Drift history + local notification on change; dashboard toggle; Android permissions"
  },
  "Result 55": {
    "summary": "Workmanager 30min task; IpChangeBackgroundRunner; flutter_local_notifications on IP change; BackgroundMonitorSettingTile; main.dart init; ip_change_detector_test (15 Flutter tests green).",
    "paths": {
      "runner": "lib/core/background/ip_change_background_runner.dart",
      "service": "lib/core/background/background_ip_monitor_service.dart",
      "callback": "lib/core/background/workmanager_callback.dart"
    },
    "deferred": [
      "FCM push for IP change",
      "iOS BGTask tuning and notification permission UX",
      "Retrofit IpnoteClient migration"
    ],
    "nextStage": "Retrofit client wiring or product polish (in-app review, haptics)"
  }
}
```
