# Cursor Plan — Ntk.Note.IP (Stage S7 wrap-up)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 32",
    "updatedAt": "2026-05-30T13:30:00+03:30",
    "previousPart": "Cursor.31.plan.md"
  },
  "Part 32": {
    "title": "Stage S7 wrap-up — Flutter CI, runbook, history clear",
    "goal": "GitHub Actions flutter-mobile.yml; scripts/flutter-ci.ps1; docs/runbooks/flutter-mobile.md; clear local history on home"
  },
  "Result 32": {
    "summary": "CI workflow for flutter pub get, gen-l10n, dart analyze, flutter test; local flutter-ci.ps1; runbook; home clear history button; README-IPNote.fa + Mobile README links.",
    "deliverables": {
      "ci": ".github/workflows/flutter-mobile.yml",
      "script": "scripts/flutter-ci.ps1",
      "runbook": "docs/runbooks/flutter-mobile.md",
      "polish": "historyClear on home (IpHistoryStore.clear)"
    },
    "s7Complete": {
      "batches": "26-32 (Flutter scaffold through wrap-up)",
      "routes": ["/", "/tools", "/login", "/dashboard", "/ip-notes"],
      "deferredGlobal": ["Drift/Hive", "OpenAPI codegen", "ping/traceroute API", "Playwright mobile E2E"]
    },
    "quality": {
      "localFlutterCi": "dart analyze + flutter test pass",
      "dotnetBuild": "run separately when AppHost not locking Web DLL"
    },
    "nextStage": "Stage S8 or production hardening per IPNote.plan"
  }
}
```
