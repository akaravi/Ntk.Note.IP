# Cursor Plan — Ntk.Note.IP (Stage S3 batch 3)

منبع: `plan.prompt/IPNote.plan.prompt.json` — Part 4 / Stage S3

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S3",
    "part": "Part 7",
    "updatedAt": "2026-05-29T15:00:00+03:30",
    "previousPart": "Cursor.6.plan.md"
  },
  "Part 7": {
    "title": "Stage S3 — ResolveDns + IpNotes Angular UI",
    "goal": "S3-009 ResolveDns، اعتبارسنجی دامنه، UI یادداشت IP و DNS در Angular"
  },
  "Result 7": {
    "summary": "ResolveDns query with DnsClient/Fake providers; /api/Dns/ResolveDns; Angular /ip-notes CRUD; DNS table on /ip-lookup.",
    "application": {
      "queries": ["ResolveDnsQuery (S3-009)"],
      "validation": "DomainNameValidator",
      "interfaces": ["IDnsResolutionService"]
    },
    "infrastructure": {
      "providers": ["DnsClientResolutionService", "FakeDnsResolutionService"],
      "package": "DnsClient 1.8.0",
      "config": "Dns:Provider = Fake | DnsClient"
    },
    "api": {
      "route": "/api/Dns/ResolveDns?domain=&types=",
      "recordTypes": ["A", "AAAA", "MX", "TXT", "NS", "CNAME", "SOA"]
    },
    "angular": {
      "routes": ["/ip-notes (auth)", "DNS section on /ip-lookup"],
      "services": ["DnsService", "IpNotesService"]
    },
    "tests": {
      "domainValidatorUnit": 3,
      "functionalResolveDns": 2,
      "totalPipeline": 57
    },
    "deferred": [
      "S3-007 GetWhoisIp",
      "S3-011 CheckBlacklist",
      "S3-010 DnsPropagation"
    ],
    "nextStage": "Whois / Blacklist or Stage S4 Infrastructure"
  }
}
```
