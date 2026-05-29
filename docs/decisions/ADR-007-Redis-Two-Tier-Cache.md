# ADR-007: Two-tier cache (Memory + Redis)

## Status

Accepted

## Context

IP lookup and DNS provider responses are expensive (HTTP latency, rate limits). Production should share cache across instances.

## Decision

- Introduce `ICacheService` with memory L1 and optional Redis L2 (`IDistributedCache` via StackExchange.Redis).
- When `ConnectionStrings:redis` is set (Aspire AppHost or manual config), register distributed cache and Redis health check (`ready` tag).
- `CachedIpLookupProvider` uses `ICacheService` instead of `IMemoryCache` directly.

## Consequences

- Local `dotnet run` on Web without Aspire: memory-only cache (no Redis required).
- Aspire AppHost adds Redis container and wires `WithReference(redis)` to Web API.
