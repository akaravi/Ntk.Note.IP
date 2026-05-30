# Cursor Plan — Ntk.Note.IP (Stage S7 batch 4)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 29",
    "updatedAt": "2026-05-30T10:30:00+03:30",
    "previousPart": "Cursor.28.plan.md"
  },
  "Part 29": {
    "title": "Stage S7 — Local IP history + dashboard timeline",
    "goal": "S7-022..024 subset: ipnote.ip-history schema v1 in shared_preferences; record on lookup; home recent list; dashboard merge local+server timeline with stats/search/country chips"
  },
  "Result 29": {
    "summary": "IpHistoryStore (50 entries, web-aligned key); auto-record from GetIpDetails; home recent history; dashboard timeline from local + GET /api/v1/IpLookup when authenticated; deep link /?address= from dashboard.",
    "flutter": {
      "localHistory": {
        "key": "ipnote.ip-history",
        "schemaVersion": 1,
        "maxEntries": 50
      },
      "api": "GET /api/v1/IpLookup (data array of IpLookupRecordDto)",
      "dashboard": [
        "stats row (total, unique IPs, countries)",
        "country FilterChips",
        "search field",
        "timeline ListTile → home with address query"
      ],
      "packagesAdded": ["uuid"]
    },
    "quality": {
      "dartAnalyze": "no issues",
      "flutterTest": "1 passed"
    },
    "deferred": [
      "S7-023 server/local sync merge upload",
      "S7-026 ip notes on timeline",
      "S7-028 CSV/JSON export",
      "S7-025 aggregate OSM map on dashboard",
      "Drift migration from prefs"
    ],
    "nextStage": "S7 batch 5: ip notes screen, history sync, or curl tabs"
  }
}
```
