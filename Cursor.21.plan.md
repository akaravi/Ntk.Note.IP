# Cursor Plan — Ntk.Note.IP (Stage S6 batch 2)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S6",
    "part": "Part 21",
    "updatedAt": "2026-05-30T02:00:00+03:30",
    "previousPart": "Cursor.20.plan.md"
  },
  "Part 21": {
    "title": "Stage S6 — history, map, network/device cards, curl tabs, live IP",
    "goal": "S6-013–S6-022, S6-018 subset: localStorage history v1, OSM map, ISP card, device card, CLI tabs, 60s IP poll"
  },
  "Result 21": {
    "summary": "IpHistoryService (schema v1, 50 max); browser history UI with clear/remove; OpenStreetMap static map; ISP/ASN network card; device/browser card; curl/PowerShell/MikroTik tabs; live IP refresh every 60s on change.",
    "frontend": {
      "services": [
        "core/ip-history.service.ts",
        "core/device-info.service.ts",
        "ip-lookup/curl-command-snippets.ts"
      ],
      "features": [
        "S6-019–022 local history",
        "S6-013 map embed",
        "S6-014 network card",
        "S6-015 device card",
        "S6-016 command tabs",
        "S6-018 poll GetMyIp"
      ],
      "i18nKeys": 95
    },
    "tests": { "totalPipeline": 54 },
    "deferred": [
      "S6-017 code snippets C#/JS/Python",
      "S6-023 merge history after login",
      "S6-024+ OAuth/2FA/dashboard",
      "PWA/E2E"
    ],
    "nextStage": "S6 batch 3 — code snippets, history sync on login, home i18n"
  }
}
```
