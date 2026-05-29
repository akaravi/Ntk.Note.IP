# Cursor Plan — Ntk.Note.IP (Stage S6 batch 4)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S6",
    "part": "Part 23",
    "updatedAt": "2026-05-30T04:00:00+03:30",
    "previousPart": "Cursor.22.plan.md"
  },
  "Part 23": {
    "title": "Stage S6 — dashboard timeline, filters, export, nav/auth/notes i18n",
    "goal": "S6-027–029, S6-031, S6-034 subset; ip-notes UX; login/register i18n"
  },
  "Result 23": {
    "summary": "/dashboard (AuthGuard): timeline from local history + server lookups + notes; stats; search/country filter; CSV/JSON export. Nav i18n; ip-notes polish (tags, my IP, deep links); login/register fa-en.",
    "frontend": {
      "routes": ["/dashboard"],
      "modules": [
        "dashboard/dashboard.component",
        "dashboard/dashboard-timeline.ts"
      ],
      "i18nKeys": 136
    },
    "tests": { "totalPipeline": 54 },
    "deferred": [
      "S6-024 OAuth",
      "S6-030 aggregate map",
      "S6-033 diff compare",
      "S6-035 alerts",
      "PWA/E2E"
    ],
    "nextStage": "S6 batch 5 — tools page split or run-all verification"
  }
}
```
