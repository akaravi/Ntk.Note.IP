# Local dev — run-all

## Command

```powershell
.\scripts\run-all.ps1
```

## What it does

1. `build.ps1` — Debug compile + unit/functional/architecture tests + i18n keys
2. `flutter-ci.ps1` — `dart analyze` + `flutter test` (skip with `-SkipFlutter`)
3. Starts **Aspire AppHost** in background; logs to `artifacts/logs/apphost-*.log`
4. Discovers Web API URL (`discover-web-base-url.ps1`) — `localhost:5340`, `5341`, or URLs from log
5. `verify-health.ps1` + well-known/changelog smoke (`post-deploy-smoke.ps1` subset)
6. Optional TLS probe with `-CheckSsl` on `https://localhost:5341/health`
7. Scans AppHost log tail for error-like lines (`scan-run-log.ps1`)
8. Prints service URL list

## Restart

```powershell
.\scripts\restart-all.ps1
```

Stops prior `dotnet` processes under `Ntk.Note.IP` and re-runs `run-all.ps1 -Restart`.

## Options

| Switch | Effect |
|--------|--------|
| `-SkipBuild` | Skip `build.ps1` |
| `-SkipFlutter` | Skip Flutter CI |
| `-UseRedisContainer` | Set `IPNOTE_USE_REDIS_CONTAINER=true` for AppHost |
| `-SkipHealth` | Do not wait for health / smoke |
| `-CheckSsl` | Probe HTTPS dev cert on port 5341 |
| `-WebBaseUrl` | Fixed base URL (skip discovery) |
| `-StartupWaitSeconds` | Discovery timeout (default 90) |

## Related

- `scripts/run-verify-all.ps1` — CI-style verify without starting AppHost
- `scripts/post-deploy-smoke.ps1` — staging/production deploy checks
