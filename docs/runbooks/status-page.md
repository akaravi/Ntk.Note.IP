# Public status page

## URL

**`/status.html`** — static page served from `src/Web/wwwroot/status.html` (not Angular SPA).

Checks every 60 seconds (browser):

- `/health`
- `/alive`
- `/health/ready`
- `/api/v1/IpLookup/GetMyIp`

## Theming

Uses `prefers-color-scheme` and CSS variables for light/dark (no fixed `#fff` / `#000` chrome).

## Production

1. Link from footer or `status.ipnote.ir` CNAME to same host `/status.html`.
2. Do not cache aggressively at CDN for HTML (or short TTL) so users see fresh checks.
3. Optional: dedicated subdomain behind same Web app.

## External status products

For SLA reporting, mirror probes in UptimeRobot/Better Stack ([uptime-monitoring.md](uptime-monitoring.md)) and use this page for human-readable summary.

## Related

- [observability-baseline.md](../observability/observability-baseline.md)
- [on-call.md](on-call.md)
