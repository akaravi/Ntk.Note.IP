# Cursor Plan — Ntk.Note.IP (Stage S6 batch 3)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S6",
    "part": "Part 22",
    "updatedAt": "2026-05-30T03:00:00+03:30",
    "previousPart": "Cursor.21.plan.md"
  },
  "Part 22": {
    "title": "Stage S6 — code snippets, history sync on login, home i18n",
    "goal": "S6-017, S6-023, home page i18n"
  },
  "Result 22": {
    "summary": "CODE tabs C#/JS/Python/Bash; IpHistorySyncService merges server GetListIpLookupRecords into localStorage and uploads missing via ActionLookup after login/init; home page uses I18nService; AuthService triggers sync.",
    "frontend": {
      "services": [
        "core/ip-history-sync.service.ts",
        "ip-lookup/code-snippet-samples.ts"
      ],
      "api": [
        "IpLookupService.getListIpLookupRecords",
        "IpLookupService.actionLookup"
      ],
      "i18nKeys": 106
    },
    "tests": { "totalPipeline": 54 },
    "deferred": [
      "S6-024 OAuth login",
      "S6-028 dashboard timeline",
      "PWA/E2E"
    ],
    "nextStage": "S6 batch 4 — dashboard route, ip-notes UX polish, or run-all"
  }
}
```
