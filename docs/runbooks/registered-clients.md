# Registered API clients (CORS + optional HMAC)

Browser and mobile web clients are registered under `Clients` in `appsettings.json`. CORS merges **all** `Clients:*:AllowedOrigins` plus optional extra entries in `Cors:AllowedOrigins`.

## Client ids

| Client id | Host | Local ports (this repo) |
|-----------|------|-------------------------|
| `panel-web` | Angular dashboard / SPA | 5340–5342, 4200 |
| `flutter-app` | Flutter web + App hosts | 5349, 5315–5316 |

## Configuration

Backend: `src/Web/appsettings.json`

| Client | Local appsettings |
|--------|-------------------|
| `panel-web` | `src/Web/ClientApp/appsettings.json` |
| `flutter-app` | `src/Mobile/ntk_note_ip_app/appsettings.json` |

Production variants: `appsettings.Production.json` in each client folder (loaded automatically in release builds).

**Server** (`src/Web/appsettings.json`) — all clients + CORS origins:

```json
"Clients": {
  "panel-web": {
    "Secret": "CHANGE_ME_PANEL_HMAC_SECRET_32B_MIN",
    "AllowedOrigins": [ "https://ipnote.ir", "..." ]
  },
  "flutter-app": {
    "Secret": "CHANGE_ME_FLUTTER_HMAC_SECRET_32B_MIN",
    "AllowedOrigins": [ "https://app.ipnote.ir", "..." ]
  }
}
```

**Each client app** — only its own identity (no `Clients` wrapper, no `AllowedOrigins`, no other app's secret):

```json
{
  "ClientId": "panel-web",
  "ApiBaseUrl": "https://ipnote.ir",
  "Secret": "CHANGE_ME_PANEL_HMAC_SECRET_32B_MIN"
}
```

## Production secrets

Do not commit real secrets. Set via environment or User Secrets:

```powershell
dotnet user-secrets set "Clients:panel-web:Secret" "<random-32b+>" --project src/Web
dotnet user-secrets set "Clients:flutter-app:Secret" "<random-32b+>" --project src/Web
```

Or environment variables:

`Clients__panel-web__Secret`, `Clients__flutter-app__Secret`

## Optional HMAC attestation

When `Secret` is not a `CHANGE_ME_*` placeholder and the client sends headers on `/api/*`:

| Header | Value |
|--------|--------|
| `X-Client-Id` | `panel-web` or `flutter-app` |
| `X-Client-Timestamp` | Unix seconds (UTC) |
| `X-Client-Signature` | Lowercase hex HMAC-SHA256 of `{clientId}:{timestamp}:{METHOD}:{path}{query}` |

If headers are omitted, the request proceeds (browser CORS-only flow). Native Flutter/Android/iOS are not CORS-bound.

## Verify CORS

```powershell
curl.exe -i -X OPTIONS `
  -H "Origin: https://app.ipnote.ir" `
  -H "Access-Control-Request-Method: GET" `
  https://ipnote.ir/api/v1/IpLookup/GetMyIp
```

See [ADR-015](../decisions/ADR-015-Registered-Clients.md).
