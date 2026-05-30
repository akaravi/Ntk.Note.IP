# Cursor Plan — Ntk.Note.IP (Stage S6 batch 5)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S6",
    "part": "Part 24",
    "updatedAt": "2026-05-30T05:00:00+03:30",
    "previousPart": "Cursor.23.plan.md"
  },
  "Part 24": {
    "title": "Stage S6 — aggregate map, tools hub, IP compare",
    "goal": "S6-030, S6-033 subset, S6-037–042 hub; login → dashboard default"
  },
  "Result 24": {
    "summary": "Dashboard country chips + OSM aggregate map (up to 12 IPs); /tools hub with cards → ip-lookup?focus=; side-by-side IP compare; nav/home links; login default /dashboard.",
    "frontend": {
      "routes": ["/tools"],
      "features": [
        "S6-030 aggregate map",
        "S6-033 compare two IPs",
        "tools hub + deep-link scroll on ip-lookup"
      ],
      "i18nKeys": 161
    },
    "tests": { "totalPipeline": 54 },
    "deferred": [
      "S6-024 OAuth",
      "S6-035 alerts",
      "S6-037 ping realtime",
      "PWA/E2E",
      "run-all verification"
    ],
    "nextStage": "S6 batch 6 — PWA manifest or run-all + health checks"
  }
}
```
