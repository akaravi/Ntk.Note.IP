# Cursor Plan — Ntk.Note.IP (Stage S8 batch 3)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S8",
    "part": "Part 35",
    "updatedAt": "2026-05-30T17:00:00+03:30",
    "previousPart": "Cursor.34.plan.md"
  },
  "Part 35": {
    "title": "Stage S8 — coverlet gate, Dashboard E2E, k6 smoke",
    "goal": "S8-002 coverlet; S8-009 dashboard E2E; S8-017 k6 smoke on GetMyIp/health"
  },
  "Result 35": {
    "summary": "coverlet.runsettings + scripts/coverage.ps1 (30% line gate); build.ps1 -Coverage; CI coverage step; Dashboard.feature E2E; tests/load/smoke.js + run-k6-smoke.ps1; runbooks.",
    "coverage": {
      "script": "scripts/coverage.ps1",
      "minLinePercent": 30,
      "baselineNote": "~37% combined at batch time"
    },
    "e2e": {
      "added": "Dashboard.feature (login → stats visible)"
    },
    "load": {
      "script": "scripts/run-k6-smoke.ps1",
      "k6": "tests/load/smoke.js"
    },
    "verification": {
      "coverage": "44.3% line (gate 30%)",
      "e2e": "5 passed (IpLookup 2, Login 2, Dashboard 1)",
      "k6Local": "not installed; script ready"
    },
    "deferred": ["k6 in CI", "coverlet 50% target", "Timeline export E2E"]
  }
}
```
