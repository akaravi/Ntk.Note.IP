# ADR-012: API v1 route prefix and legacy rewrite

## Status

Accepted

## Context

IPNote.ir APIs should be versioned (`/api/v1/...`) per product plan (S5). Existing clients and curl examples used unversioned `/api/...`.

## Decision

- Register all `IEndpointGroup` routes under `/api/v1/{GroupName}` via `ApiRoutes.Group`.
- Use `UseRewriter` to rewrite `/api/*` → `/api/v1/*` when the path is not already versioned.
- OpenAPI document lists v1 paths only; legacy paths remain callable without duplicate endpoint names.

## Consequences

- New clients should call `/api/v1/...`.
- Old `/api/...` URLs keep working during migration.
- Template Todo/Weather HTTP endpoints removed from Web; domain Todo remains for internal/outbox tests only.
