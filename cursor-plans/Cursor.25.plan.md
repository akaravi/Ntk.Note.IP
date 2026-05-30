# Cursor Plan — Ntk.Note.IP (Stage S6 batch 6)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S6",
    "part": "Part 25",
    "updatedAt": "2026-05-30T06:00:00+03:30",
    "previousPart": "Cursor.24.plan.md"
  },
  "Part 25": {
    "title": "Stage S6 — PWA manifest, service worker, run-all health verification",
    "goal": "PWA shell; scripts/verify-health.ps1; Aspire run-all smoke"
  },
  "Result 25": {
    "summary": "manifest.webmanifest + sw.js + offline.html; PwaService registration; ADR-017; verify-health.ps1; Aspire AppHost running; all health probes 200 on :5000.",
    "pwa": {
      "manifest": "ClientApp/src/assets/manifest.webmanifest",
      "serviceWorker": "ClientApp/src/assets/sw.js",
      "adr": "docs/decisions/ADR-017-PWA-Web-Manifest.md"
    },
    "runAll": {
      "aspireDashboard": "http://ntk.note.ip.dev.localhost:15000",
      "webApi": "http://localhost:5000",
      "scalar": "http://localhost:5000/scalar",
      "health": [
        "http://localhost:5000/health",
        "http://localhost:5000/alive",
        "http://localhost:5000/health/ready",
        "http://localhost:5000/api/v1/IpLookup/GetMyIp"
      ],
      "httpsProfile": "not started (http launch profile only)",
      "script": "scripts/verify-health.ps1"
    },
    "build": {
      "angularProduction": "pass after style budget 6kb",
      "testsPipeline": 54
    },
    "deferred": ["S6-024 OAuth", "S6-035 alerts", "Playwright E2E"],
    "nextStage": "Stage S7 or production hardening"
  }
}
```
