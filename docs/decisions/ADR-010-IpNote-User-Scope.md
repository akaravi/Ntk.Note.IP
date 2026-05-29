# ADR-010: IpNote scoped to authenticated user

## Status

Accepted

## Context

IP notes are private per account. `CreatedBy` is populated by `AuditableEntityInterceptor` from `IUser.Id`.

## Decision

- All IpNote queries and commands filter by `CreatedBy == current user id`.
- Cross-tenant access returns `NotFound` (same as missing id) to avoid leaking existence.

## Consequences

- List/GetOne/Update/Delete only see the caller's notes.
- Functional tests verify isolation between two users.
