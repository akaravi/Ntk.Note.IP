# Cursor Plan — Ntk.Note.IP (Post-S9 Part 50)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 50",
    "updatedAt": "2026-05-30T14:00:00+03:30",
    "previousPart": "Cursor.49.plan.md"
  },
  "Part 50": {
    "title": "Flutter App Links + deploy well-known smoke",
    "goal": "Android autoVerify intent-filters; iOS associated domains; /ip-lookup go_router redirect; deep_link_uri tests; post-deploy-smoke well-known URLs"
  },
  "Result 50": {
    "summary": "Android VIEW + autoVerify for ipnote.ir; Runner.entitlements applinks; app_router /ip-lookup redirect; deep_link_uri.dart + tests; post-deploy-smoke assetlinks/AASA/changelog/status.",
    "paths": {
      "androidManifest": "src/Mobile/ntk_note_ip_app/android/app/src/main/AndroidManifest.xml",
      "iosEntitlements": "src/Mobile/ntk_note_ip_app/ios/Runner/Runner.entitlements",
      "deepLinkMapper": "src/Mobile/ntk_note_ip_app/lib/core/navigation/deep_link_uri.dart"
    },
    "deferred": [
      "Replace TEAMID and release SHA256 in wwwroot before Go-Live",
      "End-to-end App Links verification on physical devices after release signing"
    ],
    "nextStage": "Product backlog from IPNote.plan or run-all orchestration enhancements"
  }
}
```
