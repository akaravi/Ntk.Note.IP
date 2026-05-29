# ADR-005: SQLite for Local Development Database

## Status

Accepted — 2026-05-29

## Context

The solution started from Jason Taylor's Clean Architecture template with optional PostgreSQL, SQL Server, or SQLite. IPNote Stage 0 requires a frictionless local setup without Docker (Docker not available on current dev machine).

## Decision

Use **SQLite** for local development and Aspire orchestration:

- `AppHost`: `AddSqlite(Services.Database)`
- `Infrastructure`: `UseSqlite(connectionString)`
- Package: `Microsoft.EntityFrameworkCore.Sqlite` + `CommunityToolkit.Aspire.Hosting.SQLite`

Production database (PostgreSQL or SQL Server) will be decided in a later ADR when deployment targets are fixed.

## Consequences

- Zero Docker dependency for dev.
- Some PostgreSQL/SQL Server-specific features unavailable locally.
- Migration path: add provider-specific ADR and environment-specific connection strings before production.
