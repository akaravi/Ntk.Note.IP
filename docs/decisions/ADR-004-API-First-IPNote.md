# ADR-004: API-First for IPNote.ir

## Status

Accepted — 2026-05-29

## Context

IPNote.ir serves multiple clients (Angular web, Flutter mobile). Business logic must not diverge between platforms. The product requires IP lookup, history, geo/ASN enrichment, and user-specific notes — all exposed as stable contracts.

## Decision

Adopt **API-First** architecture:

- Single ASP.NET Core backend (`Web` host today; dedicated `Api` project in Stage 1 if split).
- OpenAPI as contract source; clients generate typed clients (NSwag for Angular, OpenAPI Generator for Flutter).
- Application layer owns use cases (CQRS/MediatR); controllers/endpoints are thin.
- Uniform result envelope for operational responses (`isSuccess`, message, typed `data` payload).
- List endpoints return homogeneous arrays in `data`, not redundant `{ items: [] }` wrappers.

## Consequences

- Faster parallel client development.
- Contract tests and breaking-change detection via OpenAPI diff.
- Requires linked client package updates when API changes (same PR/task).

## Related

- Plan: `plan.prompt/IPNote.plan.prompt.json` Stage S1+
- Existing OpenAPI: `src/Web/wwwroot/openapi/v1.json`
