# Cursor Plan — Ntk.Note.IP (Stage S3 continued)

منبع: `plan.prompt/IPNote.plan.prompt.json` — Part 4 / Stage S3

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S3",
    "part": "Part 6",
    "updatedAt": "2026-05-29T14:15:00+03:30",
    "previousPart": "Cursor.5.plan.md (Stage S3 batch 1)"
  },
  "Part 6": {
    "title": "Stage S3 — GetIpDetails, geo/ASN/PTR, Angular UI",
    "goal": "S3-003 تا S3-006 + صفحه Angular با i18n فارسی"
  },
  "Result 6": {
    "summary": "GetIpDetails composite query, GetGeoLocation, GetAsnInfo, GetReverseDns; IDnsLookupService; Angular /ip-lookup page with I18nService.",
    "application": {
      "queries": [
        "GetIpDetailsQuery (S3-003)",
        "GetGeoLocationQuery (S3-004)",
        "GetAsnInfoQuery (S3-005)",
        "GetReverseDnsQuery (S3-006)"
      ],
      "dto": ["IpDetailsDto", "GeoLocationDto", "AsnInfoDto", "ReverseDnsDto"],
      "mapper": "IpLookupMapper (ASN parse, geo/asn/details)"
    },
    "infrastructure": {
      "dns": "SystemDnsLookupService (PTR via System.Net.Dns)",
      "provider": "IpLookupResultDto extended with lat/lon/timezone"
    },
    "api": {
      "newEndpoints": [
        "GET GetIpDetails?address=",
        "GET GetGeoLocation?address=",
        "GET GetAsnInfo?address=",
        "GET GetReverseDns?address="
      ]
    },
    "angular": {
      "route": "/ip-lookup",
      "components": ["IpLookupComponent", "IpLookupService", "I18nService"],
      "assets": "ClientApp/src/assets/i18n/fa.json + en.json",
      "nav": "IPNote.ir brand + IP Lookup link"
    },
    "tests": {
      "applicationUnitAsnMapper": 2,
      "functionalIpLookup": 6,
      "totalPipeline": 51
    },
    "deferred": [
      "S3-007 Whois",
      "S3-009 ResolveDns",
      "S3-011 Blacklist",
      "Guest rate limit"
    ],
    "nextStage": "S3 — DNS/WHOIS queries or IpNotes Angular CRUD UI"
  }
}
```
