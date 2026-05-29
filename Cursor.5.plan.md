# Cursor Plan — Ntk.Note.IP (Stage S3)

منبع: `plan.prompt/IPNote.plan.prompt.json` — Part 4 / Stage S3

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S3",
    "part": "Part 5",
    "updatedAt": "2026-05-29T13:30:00+03:30",
    "previousPart": "Cursor.4.plan.md (Stage S2)"
  },
  "Part 5": {
    "title": "Stage S3 — IP Lookup CQRS + providers",
    "goal": "GetMyIp، ActionLookup با ذخیره IpLookupRecord، تاریخچه GetList/GetOne، provider قابل تعویض"
  },
  "Result 5": {
    "summary": "Core S3 batch: IIpLookupProvider (Fake + IpApi), IClientIpResolver, CQRS handlers, REST /api/IpLookup with ErrorExceptionResult envelope.",
    "application": {
      "featureFolder": "Application/IpLookup",
      "handlers": [
        "GetMyIpQuery (S3-002)",
        "ActionLookupIpCommand (lookup + persist)",
        "GetListIpLookupRecordsQuery",
        "GetOneIpLookupRecordQuery"
      ],
      "interfaces": ["IIpLookupProvider", "IClientIpResolver"]
    },
    "infrastructure": {
      "providers": ["FakeIpLookupProvider (default)", "IpApiLookupProvider (IpLookup:Provider=IpApi)"],
      "config": "appsettings.json IpLookup section"
    },
    "api": {
      "baseRoute": "/api/IpLookup",
      "endpoints": [
        "GET GetMyIp — anonymous",
        "POST ActionLookup — anonymous",
        "GET GetList — auth, data: IpLookupRecordDto[]",
        "GET GetOne/{id} — auth"
      ]
    },
    "tests": {
      "functionalIpLookup": 3,
      "totalPipeline": 46
    },
    "deferred": [
      "S3-003 GetIpDetails composite query",
      "S3-004–S3-019 DNS/WHOIS/ping/traceroute",
      "Guest rate limit S2-046",
      "IGeoLocationProvider split interfaces S2-054+"
    ],
    "nextStage": "S3 continued — GetIpDetails, DNS, Angular IP lookup UI"
  }
}
```
