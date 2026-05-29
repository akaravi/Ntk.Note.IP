# Cursor Plan — Ntk.Note.IP (Stage S7 batch 5)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 30",
    "updatedAt": "2026-05-30T11:30:00+03:30",
    "previousPart": "Cursor.29.plan.md"
  },
  "Part 30": {
    "title": "Stage S7 — History sync, IP notes, dashboard export & map",
    "goal": "S7-023..028 subset: IpHistorySync after login; IpNotes CRUD; dashboard notes in timeline; aggregate OSM map; CSV/JSON share export"
  },
  "Result 30": {
    "summary": "IpHistorySyncService merges server list into local and ActionLookup uploads missing; /ip-notes screen (GetList/Add/Delete); dashboard includes notes, aggregate map via GetIpDetails markers, share_plus CSV/JSON export.",
    "flutter": {
      "sync": "IpHistorySyncService on login + stored token load; reset on logout",
      "ipNotes": {
        "routes": "/ip-notes",
        "api": [
          "GET /api/v1/IpNotes",
          "POST /api/v1/IpNotes",
          "DELETE /api/v1/IpNotes/{id}"
        ]
      },
      "dashboard": [
        "timeline with note items",
        "aggregate OSM static map (up to 12 lookup IPs)",
        "export CSV/JSON via share_plus",
        "statNotes chip"
      ],
      "packagesAdded": ["share_plus"]
    },
    "quality": {
      "dartAnalyze": "no issues",
      "flutterTest": "1 passed"
    },
    "deferred": [
      "S7-020 curl command tabs on home",
      "S7-029 ping/traceroute tools",
      "60s IP poll",
      "Drift migration",
      "UpdateIpNote edit"
    ],
    "nextStage": "S7 batch 6: tools screen subset or production polish"
  }
}
```
