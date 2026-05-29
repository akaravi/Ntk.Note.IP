# ADR-014: Configurable CORS

## Status

Accepted

## Context

Production must not use `AllowAnyOrigin` when credentials (cookies) are used. Development still needs permissive CORS for local Angular.

## Decision

- `Cors:AllowedOrigins` in environment-specific settings:
  - `appsettings.Development.json` — local SPA/API origins (`localhost:5340`, `5342`, etc.)
  - `appsettings.Production.json` — `https://ipnote.ir`, `https://www.ipnote.ir`, `https://noteip.ir`, `https://www.noteip.ir`
- Base `appsettings.json` keeps an empty array; Development/Production files supply origins.
- When origins are configured: `WithOrigins` + `AllowCredentials`.
- When empty and `Development`: allow any origin (no credentials policy).
- When empty and not Development: no permissive CORS middleware (same-site SPA only).

## Consequences

- Set explicit origins in production deployment config.
- Flutter/mobile native clients are not browser CORS-bound.
