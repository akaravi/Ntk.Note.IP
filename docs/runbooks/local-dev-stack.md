# Local dev stack — runbook

Port map: [local-dev-ports.md](local-dev-ports.md) (5340–5349).

## Full verification (build + tests + health)

```powershell
# With AppHost already running:
.\scripts\run-verify-all.ps1 -SkipBuild

# Full pipeline including build/tests and start AppHost:
.\scripts\run-verify-all.ps1 -StartAppHost

# Include Playwright E2E:
.\scripts\run-verify-all.ps1 -IncludeE2e
```

## Backend coverage (coverlet)

```powershell
.\scripts\coverage.ps1
# or via build.ps1:
.\build.ps1 -Coverage
```

Default minimum line coverage: **40%** (combined Domain + Application unit + functional tests).

## Start / restart stack

```powershell
.\scripts\run-all.ps1
# or
.\scripts\restart-all.ps1
```

## Health probes

```powershell
.\scripts\verify-health.ps1
```

Default URLs:

| Service | URL |
|---------|-----|
| Aspire dashboard | http://ntk.note.ip.dev.localhost:5343 |
| Web API (HTTP) | http://localhost:5340 |
| Web API (HTTPS) | https://localhost:5341 |
| Angular dev (Aspire) | http://localhost:5342 |
| Scalar | http://localhost:5340/scalar |
| Health | http://localhost:5340/health |
| Hangfire (dev) | http://localhost:5340/hangfire |

## Flutter mobile

```powershell
.\scripts\flutter-ci.ps1
```

See [flutter-mobile.md](flutter-mobile.md).

## Playwright E2E (Aspire + Angular dev server)

```powershell
.\scripts\run-e2e.ps1
```

Includes IP lookup smoke (My IP visible, lookup → browser history). Requires Chromium (installed via `playwright.ps1`).

Full verify with E2E:

```powershell
.\scripts\run-verify-all.ps1 -IncludeE2e
```

## Background jobs (Hangfire)

Registered in `HangfireJobRegistration`:

- `geoip-mmdb-refresh` — daily
- `outbox-dispatch` — every minute
- `push-ip-monitor-poll` — every 15 min (when `Push:Enabled`; wakes app to call `ActionMonitorMyIp`)

Dashboard: Development only, `/hangfire` (local requests).

## Related

- [readmehistory.md](../../readmehistory.md)
- [ipnote-overview.md](../architecture/ipnote-overview.md)
