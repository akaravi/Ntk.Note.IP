# ADR-014: Configurable CORS

## Status

Accepted

## Context

Production must not use `AllowAnyOrigin` when credentials (cookies) are used. Development still needs permissive CORS for local Angular.

## Decision

- `Cors:AllowedOrigins` in environment-specific settings:
  - `appsettings.Development.json` — local SPA/API origins (`localhost:5340`, `5342`, etc.)
  - `appsettings.Production.json` — `https://ipnote.ir`, `https://www.ipnote.ir`, `https://app.ipnote.ir`, `https://noteip.ir`, `https://www.noteip.ir`, `https://app.noteip.ir`
- Base `appsettings.json` lists the same production origins as fallback.
- Default CORS policy registered in `AddWebServices`; `UseCors()` runs early in the pipeline (before HTTPS redirect / auth / rate limit).

## Consequences

- Set explicit origins in production deployment config.
- Flutter/mobile native clients are not browser CORS-bound.
