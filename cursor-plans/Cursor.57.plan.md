# Cursor Plan — Ntk.Note.IP (Post-S9 Part 57)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 57",
    "updatedAt": "2026-05-30T21:00:00+03:30",
    "previousPart": "Cursor.56.plan.md"
  },
  "Part 57": {
    "title": "Auth retrofit + in-app review + S7 close checklist",
    "goal": "AuthRemoteDataSource via IpnoteClient login; auth_token_mapper; AppReviewService on dashboard; s7-stage-close-checklist.md"
  },
  "Result 57": {
    "summary": "ipnoteAuthClientProvider; LoginRequest via retrofit; AppReviewService threshold 5; auth_token_mapper_test; docs/mobile/s7-stage-close-checklist.md.",
    "paths": {
      "auth": "lib/data/datasources/auth_remote_datasource.dart",
      "review": "lib/core/feedback/app_review_service.dart",
      "checklist": "docs/mobile/s7-stage-close-checklist.md"
    },
    "deferred": [
      "FCM push for IP change",
      "Refresh token rotation via IpnoteClient",
      "Store release signing CI"
    ],
    "nextStage": "Go-Live placeholders or product backlog from IPNote.plan Part 1+"
  }
}
```
