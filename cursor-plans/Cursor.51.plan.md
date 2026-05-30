# Cursor Plan — Ntk.Note.IP (Post-S9 Part 51)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 51",
    "updatedAt": "2026-05-30T15:00:00+03:30",
    "previousPart": "Cursor.50.plan.md"
  },
  "Part 51": {
    "title": "run-all orchestration + Flutter secure token storage",
    "goal": "run-all.ps1: build, Flutter CI, AppHost background, URL discovery, health+well-known smoke, log scan, URL list; flutter_secure_storage for auth tokens with prefs migration"
  },
  "Result 51": {
    "summary": "run-all.ps1 6-step dev orchestration; discover-web-base-url.ps1; scan-run-log.ps1; restart-all delegates -Restart; AuthTokenStore uses flutter_secure_storage + legacy migration; local-dev-run-all.md.",
    "scripts": [
      "scripts/run-all.ps1",
      "scripts/discover-web-base-url.ps1",
      "scripts/scan-run-log.ps1",
      "scripts/restart-all.ps1"
    ],
    "deferred": [
      "Physical App Links verification after release signing",
      "Replace TEAMID / SHA256 in wwwroot before Go-Live"
    ],
    "nextStage": "Product features from IPNote.plan S7 (biometric, push) or OpenAPI codegen"
  }
}
```
