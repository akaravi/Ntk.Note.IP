# Cursor Plan — Ntk.Note.IP (Post-S9 Part 59)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 59",
    "updatedAt": "2026-05-30T23:00:00+03:30",
    "previousPart": "Cursor.58.plan.md"
  },
  "Part 59": {
    "title": "Store release prep + Go-Live deep link tooling",
    "goal": "Android release signing via key.properties; flutter-release-build.ps1; update/verify deep link scripts; store-release-checklist.md; CI placeholder warn job"
  },
  "Result 59": {
    "summary": "build.gradle.kts release signingConfig; key.properties.example; flutter-release-build.ps1; update-deep-links.ps1 + verify-deep-links-placeholders.ps1; post-deploy -StrictDeepLinks; flutter-mobile.yml deep-links-placeholders job; docs/mobile/store-release-checklist.md.",
    "paths": {
      "signing": "src/Mobile/ntk_note_ip_app/android/app/build.gradle.kts",
      "scripts": [
        "scripts/flutter-release-build.ps1",
        "scripts/update-deep-links.ps1",
        "scripts/verify-deep-links-placeholders.ps1"
      ],
      "docs": "docs/mobile/store-release-checklist.md"
    },
    "manual": [
      "Create upload keystore and key.properties",
      "Run update-deep-links.ps1 with real SHA256 + Team ID before production",
      "Play Internal / TestFlight upload"
    ],
    "deferred": [
      "FCM push for IP change",
      "GitHub Actions signed AAB (secrets)",
      "fastlane automation"
    ],
    "nextStage": "FCM optional or product backlog; physical App Links verification after signed build"
  }
}
```