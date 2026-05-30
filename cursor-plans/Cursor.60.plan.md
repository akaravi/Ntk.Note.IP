# Cursor Plan — Ntk.Note.IP (Post-S9 Part 60)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 60",
    "updatedAt": "2026-05-31T00:00:00+03:30",
    "previousPart": "Cursor.59.plan.md"
  },
  "Part 60": {
    "title": "Push foundation + Flutter release CI",
    "goal": "IPushSender/NoOpPushSender/PushOptions; flutter-release.yml; fcm-setup.md; ADR-019"
  },
  "Result 60": {
    "summary": "Application IPushSender + PushMessage; Infrastructure NoOpPushSender; Push section in appsettings; GitHub workflow flutter-release.yml (appbundle/apk artifact, optional keystore secrets); docs/mobile/fcm-setup.md; ADR-019.",
    "paths": {
      "push": "src/Application/Common/Interfaces/IPushSender.cs",
      "ci": ".github/workflows/flutter-release.yml",
      "docs": ["docs/mobile/fcm-setup.md", "docs/decisions/ADR-019-Push-Notifications.md"]
    },
    "deferred": [
      "PushDevice entity + ActionRegister API",
      "FirebasePushSender + firebase_messaging in Flutter",
      "fastlane"
    ],
    "nextStage": "ActionRegisterPushToken API + FCM client when Firebase project ready"
  }
}
```