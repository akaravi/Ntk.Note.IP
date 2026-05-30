# Cursor Plan — Ntk.Note.IP (Post-S9 Part 49)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 49",
    "updatedAt": "2026-05-30T13:00:00+03:30",
    "previousPart": "Cursor.48.plan.md"
  },
  "Part 49": {
    "title": "Deep link verification + public changelog",
    "goal": "S9-049/100: assetlinks + AASA; changelog.html; deep-links runbook; verify-all URLs"
  },
  "Result 49": {
    "summary": "wwwroot/.well-known/assetlinks.json + apple-app-site-association; changelog.html + CHANGELOG.md; deep-links.md; ProductionHardening well-known test.",
    "paths": {
      "status": "/status.html",
      "changelog": "/changelog.html",
      "assetlinks": "/.well-known/assetlinks.json",
      "aasa": "/.well-known/apple-app-site-association"
    },
    "deferred": [
      "Replace TEAMID and release SHA256 before Go-Live"
    ],
    "nextStage": "Cursor.50.plan.md — Flutter App Links + post-deploy well-known smoke"
  }
}
```
