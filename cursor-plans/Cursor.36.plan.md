# Cursor Plan — Ntk.Note.IP (Stage S8 batch 4 / wrap)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S8",
    "part": "Part 36",
    "updatedAt": "2026-05-30T18:30:00+03:30",
    "previousPart": "Cursor.35.plan.md"
  },
  "Part 36": {
    "title": "Stage S8 — k6 CI, coverlet 40%, dashboard CSV E2E, testing strategy",
    "goal": "S8-017 CI; raise coverage gate; export E2E; S8 DoD doc"
  },
  "Result 36": {
    "summary": "load-smoke.yml (k6 vs standalone Web); MinLinePercent 40; Dashboard CSV export E2E; docs/testing/testing-strategy.md with DoD checklist.",
    "ci": {
      "workflows": ["build.yml coverage 40%", "load-smoke.yml"]
    },
    "e2e": {
      "added": "Dashboard CSV export scenario"
    },
    "verification": {
      "coverage": "44.3% line (gate 40%)",
      "e2e": "6 passed (incl. Dashboard CSV export)"
    },
    "deferred": [
      "Coverlet 50%",
      "Testcontainers",
      "OpenAPI contract tests",
      "DAST/ZAP",
      "Full S8 security/privacy audit (items 26-87 in plan)"
    ],
    "nextStage": "Production hardening or remaining S8 security items"
  }
}
```
