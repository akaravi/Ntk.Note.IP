# ADR-015: Dual authentication (cookie + bearer)

## Status

Accepted

## Context

The Angular SPA uses cookie-based Identity sign-in (`/api/v1/Users/login?useCookies=true`). Flutter and other API clients need bearer tokens without cookies.

## Decision

- Register `Smart` policy scheme: `Authorization: Bearer` → `IdentityConstants.BearerScheme`, otherwise `IdentityConstants.ApplicationScheme` (cookies).
- `AddBearerToken` with configurable `Jwt:BearerTokenExpirationHours`.
- Pipeline includes `UseAuthentication()` and `UseAuthorization()` before API endpoints.
- OpenAPI documents Bearer security via `BearerSecuritySchemeTransformer`.

## Consequences

- Web: unchanged cookie login flow.
- Mobile: `POST /api/v1/Users/login` (no `useCookies`) → use `accessToken` on API calls.
- Production CORS must list explicit origins when using cookies (`appsettings.Production.json`).
