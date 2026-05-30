# ADR-015: Registered clients (panel-web, flutter-app)

## Status

Accepted

## Context

IPNote.ir serves multiple browser clients (Angular dashboard, Flutter web on `app.ipnote.ir`) that call the API on another origin. CORS origins and optional client attestation secrets should be grouped per client, not only in a flat `Cors:AllowedOrigins` list.

## Decision

- Add `Clients:{clientId}` configuration with `Secret` and `AllowedOrigins`.
- Standard client ids: `panel-web` (Angular), `flutter-app` (Flutter web / app hosts).
- Global CORS policy = union of all client origins + legacy `Cors:AllowedOrigins`.
- `IRegisteredClientStore` resolves clients at runtime.
- Optional HMAC middleware validates `/api/*` when `X-Client-Id`, `X-Client-Timestamp`, and `X-Client-Signature` are sent and `Secret` is configured (skipped for `CHANGE_ME_*` placeholders or when headers absent).

## Consequences

- Production deploy must set real secrets via env / Key Vault.
- `appsettings.Production.json` overrides production origins per client; base `appsettings.json` includes local dev ports (5340–5349, 5315–5316).
- Flat `Cors:AllowedOrigins` remains for ad-hoc extra origins only.

## Related

- [ADR-014](ADR-014-Cors-Configuration.md)
- [registered-clients.md](../runbooks/registered-clients.md)
