# Cursor Plan — Ntk.Note.IP (Stage S3 batch 5)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S3",
    "part": "Part 9",
    "updatedAt": "2026-05-29T17:00:00+03:30",
    "previousPart": "Cursor.8.plan.md"
  },
  "Part 9": {
    "title": "Stage S3 — Whois domain, Port, SSL, guest rate limit, nav cleanup",
    "goal": "S3-008, S3-014, S3-015, S2-046 + UX"
  },
  "Result 9": {
    "summary": "GetWhoisDomain, ActionCheckPort, GetSslCertificateInfo; ASP.NET rate limiter for guest APIs; nav focused on IPNote; default route /ip-lookup.",
    "api": {
      "Whois": "GET GetWhoisDomain?domain=",
      "IpTools": ["GET ActionCheckPort?host=&port=", "GET GetSslCertificateInfo?domain=&port="]
    },
    "infrastructure": {
      "NetworkTools": "Tcp/Fake port check, Ssl Probe/Fake",
      "rateLimiting": "60 req/min per IP for anonymous; authenticated bypass"
    },
    "angular": {
      "defaultRoute": "/ip-lookup",
      "nav": "IP Lookup + IP Notes only",
      "tools": "domain WHOIS, port, SSL on lookup page"
    },
    "tests": { "totalPipeline": 66 },
    "deferred": ["S3-010 DnsPropagation", "Stage S4 PostgreSQL/Cache"],
    "nextStage": "Stage S4 Infrastructure or run all"
  }
}
```
