# ADR-009: EF Core migrations (replace EnsureCreated)

## Status

Accepted

## Context

`EnsureDeleted` + `EnsureCreated` resets data on every dev startup and cannot evolve production schema safely.

## Decision

- Store migrations under `Infrastructure/Data/Migrations`.
- Development startup calls `Database.MigrateAsync()` via `ApplicationDbContextInitialiser`.
- CI/production apply the same migrations with `scripts/migrate-database.ps1` or `dotnet ef database update`.

## Consequences

- Delete local `Ntk.Note.IP.db` only when migration history is broken.
- `IpNote` and `IpRecord` use global query filters for soft delete.
