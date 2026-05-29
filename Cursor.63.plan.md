# Cursor Plan — Ntk.Note.IP (Post-S9 Part 63)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 63",
    "updatedAt": "2026-05-31T03:00:00+03:30",
    "previousPart": "Cursor.62.plan.md"
  },
  "Part 63": {
    "title": "Server push on IP change + Flutter monitor hook",
    "goal": "UserPublicIpSnapshot; ActionMonitorMyIp API; FirebasePushSender; IUserPushNotificationService; Flutter actionMonitorMyIp on dashboard load; fix functional test IP resolver isolation"
  },
  "Result 63": {
    "summary": "Backend detects IP change per user, stores snapshot, sends push via IPushSender when changed. FirebasePushSender wired when Push:Provider=Firebase. Flutter calls ActionMonitorMyIp when authenticated (dashboard load). TestClientIpResolver reset in ActionMonitorMyIpTests TearDown.",
    "paths": {
      "entity": "src/Domain/Entities/UserPublicIpSnapshot.cs",
      "command": "src/Application/IpLookup/Commands/ActionMonitorMyIp/",
      "endpoint": "src/Web/Endpoints/IpLookup.cs",
      "push": "src/Infrastructure/Push/FirebasePushSender.cs",
      "flutter": "lib/domain/usecases/action_monitor_my_ip.dart"
    },
    "verification": {
      "dotnetBuild": "0 errors",
      "functionalTests": "38/38",
      "flutterTest": "21/21",
      "flutterAnalyze": "clean"
    },
    "config": {
      "Push:Provider": "NoOp | Firebase",
      "Push:FirebaseCredentialsPath": "path to service account JSON"
    },
    "deferred": [
      "Hangfire periodic job for all users with push tokens",
      "Production Firebase credentials on server",
      "Real google-services.json for device delivery E2E"
    ]
  }
}
```
