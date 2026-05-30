# Cursor Plan — Ntk.Note.IP (Post-S9 Part 62)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 62",
    "updatedAt": "2026-05-31T02:00:00+03:30",
    "previousPart": "Cursor.61.plan.md"
  },
  "Part 62": {
    "title": "Flutter FCM + PushDevice API client",
    "goal": "firebase_core/messaging; PushRegistrationService; register on login / unregister on logout; OpenAPI PushDevice tag; placeholder google-services.json"
  },
  "Result 62": {
    "summary": "PushBootstrap; FcmTokenProvider; PushDeviceRemoteDataSource (actionRegister/actionUnregister); auth hooks; swagger_parser PushDevice; Android google-services plugin + placeholder JSON; fcm-setup.md updated.",
    "paths": {
      "push": "lib/core/push/push_registration_service.dart",
      "android": "android/app/google-services.json"
    },
    "verification": {
      "flutterTest": "21/21 expected",
      "note": "Real FCM requires Firebase project files; server FirebasePushSender still NoOp"
    },
    "deferred": [
      "FirebasePushSender (server FCM HTTP v1)",
      "Server job to send push on IP change",
      "iOS GoogleService-Info.plist (manual)"
    ]
  }
}
```