# ADR-016: Angular SPA as web frontend

## Status

Accepted

## Context

IPNote.ir needs a responsive, bilingual (fa/en) web client with dark/light theme consuming `/api/v1` endpoints.

## Decision

- **Stack:** Angular 21 SPA hosted by ASP.NET Core (`ClientApp/`), Pico CSS v2 + custom design tokens, Lucide icons.
- **API:** NSwag-generated `web-api-client.ts` + thin feature services (`ip-lookup.service.ts`, etc.).
- **Auth:** Cookie session for SPA (`useCookies=true`); Bearer tokens for mobile (see ADR-015).
- **i18n:** JSON assets under `assets/i18n` with `I18nService` flatten keys; base locale `fa`.

## Consequences

- Blazor and React template folders are not the primary UI path.
- Flutter uses the same API contract; design tokens documented in `src/Web/ClientApp/src/design-tokens.scss`.
