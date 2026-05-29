# Cursor Plan — Ntk.Note.IP (Stage S4 batch 1)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S4",
    "part": "Part 10",
    "updatedAt": "2026-05-29T18:30:00+03:30",
    "previousPart": "Cursor.9.plan.md"
  },
  "Part 10": {
    "title": "Stage S4 — PostgreSQL ADR, cache, UoW, DNS propagation, health",
    "goal": "S4-001, S3-010 deferred, infra hardening for production path"
  },
  "Result 10": {
    "summary": "ADR-006 PostgreSQL; memory cache on IP lookup; IUnitOfWork; GetListDnsPropagation across resolvers; EF index + DbContext health; Angular propagation UI.",
    "api": {
      "Dns": "GET GetListDnsPropagation?domain=&type=A|AAAA|MX|TXT|NS|CNAME"
    },
    "infrastructure": {
      "cache": "CachedIpLookupProvider + CacheOptions (IpLookupMinutes, DnsResolveMinutes)",
      "database": "Database:Provider Sqlite (default); PostgreSQL throws until Npgsql EF10 stable",
      "dnsPropagation": "DnsPropagationChecker (Google/Cloudflare/Quad9) + Fake for dev/tests",
      "unitOfWork": "IUnitOfWork on ApplicationDbContext",
      "health": "AddDbContextCheck; /health/ready in ServiceDefaults"
    },
    "angular": {
      "ipLookup": "DNS propagation panel with resolver comparison table"
    },
    "i18n": { "keys": 65, "newDnsKeys": ["DNS.PROPAGATION", "DNS.PROPAGATION_HINT", "DNS.PROPAGATION_CHECK", "DNS.RESOLVER", "DNS.STATUS", "DNS.MATCHES", "DNS.DIFFERS"] },
    "tests": { "totalPipeline": 68, "new": ["DnsPropagationTests", "CachedIpLookupProviderTests"] },
    "fixes": ["DnsClient.Protocol usings in DnsPropagationChecker", "Removed Npgsql 9.x (EF10 mismatch)", "IIpLookupProvider using in unit test"],
    "deferred": ["Npgsql when 10.x stable", "Redis cache", "Hangfire", "MMDB geo", "run all Aspire"],
    "nextStage": "S4 batch 2 — Redis/Hangfire or run all"
  }
}
```
