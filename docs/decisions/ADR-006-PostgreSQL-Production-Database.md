# ADR-006: PostgreSQL for Production Database

## Status

Accepted — 2026-05-29

## Context

ADR-005 chose SQLite for local development without Docker. IPNote.ir production needs concurrent writes, proper indexing, inet types, and managed backups. The solution already ships optional `appsettings.PostgreSQL.json` from the Clean Architecture template.

## Decision

- **Development / Aspire tests:** remain on **SQLite** (default `Database:Provider = Sqlite`).
- **Staging / Production:** use **PostgreSQL** via `Database:Provider = PostgreSQL` and Npgsql EF Core provider with `EnableRetryOnFailure`.
- Connection strings come from environment / secrets (`ConnectionStrings:IPNoteDb`), never committed with real passwords.

## Consequences

- Infrastructure selects provider at startup from configuration (`Database:Provider`).
- **Implemented (2026-05-30):** `Npgsql.EntityFrameworkCore.PostgreSQL` 10.0.2; `DatabaseProviderConfiguration` selects `UseNpgsql` with retry; compose overlay `docker-compose.prod.postgresql.yml`.
- Hangfire uses `Hangfire.PostgreSql` storage when `Database:Provider=PostgreSQL` (schema `hangfire`).
- CI: `postgresql-migrations.yml` applies migrations against PostgreSQL 16 service container on PRs touching Infrastructure migrations.
- SQLite-specific limitations (no concurrent writers) do not affect production.
- Migrations should be generated against PostgreSQL before first prod deploy.
