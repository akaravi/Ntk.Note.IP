# Cursor Plan — Ntk.Note.IP (Stage S4 batch 3)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S4",
    "part": "Part 12",
    "updatedAt": "2026-05-29T20:30:00+03:30",
    "previousPart": "Cursor.11.plan.md"
  },
  "Part 12": {
    "title": "Stage S4 — Outbox pattern + MaxMind MMDB provider",
    "goal": "S4-012, S4-021, S4-1946"
  },
  "Result 12": {
    "summary": "OutboxMessages table; dispatch via Hangfire; MmdbGeoIpDatabase with Fake fallback; MMDB setup doc.",
    "infrastructure": {
      "outbox": "DispatchDomainEventsInterceptor enqueues when Outbox:Enabled; ProcessOutboxJob every minute",
      "geoIp": "MmdbGeoIpDatabase (MaxMind.GeoIP2 5.4.1) when Provider=Mmdb and file exists"
    },
    "docs": ["ADR-008", "docs/geo/mmdb-setup.md"],
    "config": { "Outbox": "Enabled true, BatchSize 20", "GeoIp": "MmdbPath data/GeoLite2-City.mmdb" },
    "tests": { "totalPipeline": 72, "new": ["OutboxDomainEventSerializerTests", "OutboxDispatchTests"] },
    "deferred": ["MMDB download script/CI", "run all Aspire"],
    "nextStage": "run all or S4 migrations/soft-delete"
  }
}
```
