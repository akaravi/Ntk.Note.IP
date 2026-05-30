# Cursor Plan — Ntk.Note.IP (Stage S7 batch 3)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 28",
    "updatedAt": "2026-05-30T09:30:00+03:30",
    "previousPart": "Cursor.27.plan.md"
  },
  "Part 28": {
    "title": "Stage S7 — IP details, OSM map, ISP/network cards, ActionLookup",
    "goal": "S7-015..021 subset: GetIpDetails after GetMyIp; geo/ASN/ISP cards; OSM static map; local Wi‑Fi IP; QR; device card; ActionLookup when authenticated"
  },
  "Result 28": {
    "summary": "Home loads GetMyIp then GetIpDetails; manual IP lookup field; OSM static map + external link; network/geo/device cards; qr_flutter; network_info_plus local IP; ActionLookup on authenticated sync.",
    "flutter": {
      "api": [
        "GET /api/v1/IpLookup/GetIpDetails?address=",
        "POST /api/v1/IpLookup/ActionLookup"
      ],
      "entities": ["IpDetails", "GeoLocation", "AsnInfo"],
      "packages": ["qr_flutter", "network_info_plus", "device_info_plus", "url_launcher"],
      "ui": [
        "IpMapPreview (OSM static image)",
        "InfoRow cards for geo/network",
        "QR toggle on hero",
        "TextFormField lookup"
      ],
      "l10nKeysAdded": 14
    },
    "quality": {
      "dartAnalyze": "no issues",
      "flutterTest": "1 passed"
    },
    "deferred": [
      "S7-020 curl command tabs",
      "S7-022 local history Drift/Hive",
      "S7-024 dashboard timeline",
      "flutter_map interactive map",
      "60s IP poll"
    ],
    "nextStage": "S7 batch 4: local history + dashboard timeline subset"
  }
}
```
