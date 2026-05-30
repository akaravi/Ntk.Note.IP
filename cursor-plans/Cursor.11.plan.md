# Cursor Plan — Ntk.Note.IP (Stage S4 batch 2)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S4",
    "part": "Part 11",
    "updatedAt": "2026-05-29T19:30:00+03:30",
    "previousPart": "Cursor.10.plan.md"
  },
  "Part 11": {
    "title": "Stage S4 — Two-tier cache, offline GeoIP, Hangfire, Aspire Redis",
    "goal": "S4-021, S4-1900/1905, S4-1925, ADR-007"
  },
  "Result 11": {
    "summary": "ICacheService (memory + optional Redis); IGeoIpDatabase + GeoEnrichedIpLookupProvider; Hangfire daily MMDB refresh job; Aspire Redis in AppHost; Redis health check.",
    "infrastructure": {
      "cache": "TwoTierCacheService — L1 IMemoryCache, L2 IDistributedCache when ConnectionStrings:redis",
      "geoIp": "FakeGeoIpDatabase merges into IIpLookupProvider pipeline before cache",
      "hangfire": "MemoryStorage; RecurringJob geoip-mmdb-refresh; dashboard /hangfire (dev, local only)",
      "aspire": "AddRedis(redis) + WithReference on Web API"
    },
    "docs": ["docs/decisions/ADR-007-Redis-Two-Tier-Cache.md"],
    "config": {
      "GeoIp": "Provider Fake, MmdbPath optional",
      "Cache": "RedisInstanceName ipnote:"
    },
    "tests": { "totalPipeline": 70, "new": ["TwoTierCacheServiceTests", "GeoEnrichedIpLookupProviderTests"] },
    "deferred": ["MaxMind MMDB file provider", "Outbox pattern", "run all Aspire"],
    "nextStage": "S4 batch 3 — Outbox/MMDB file or run all"
  }
}
```
