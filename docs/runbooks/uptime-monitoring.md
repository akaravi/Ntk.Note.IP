# Uptime monitoring

## GitHub Actions (built-in)

Workflow: **Uptime monitor** (`.github/workflows/uptime-monitor.yml`)

| Trigger | Behaviour |
|---------|-----------|
| Cron `*/15 * * * *` | Checks secrets `STAGING_WEB_BASE_URL` and `PRODUCTION_WEB_BASE_URL` when set |
| Manual | Choose staging and/or production |

Uses `scripts/uptime-check.ps1` → `verify-health.ps1` on `/health`, `/alive`, `/health/ready`, `/api/v1/IpLookup/GetMyIp`.

### Notifications

1. Repo **Settings → Notifications** / watch rules for workflow failures.
2. Optional: branch protection not required; add Slack/email via GitHub Actions integration or failed-workflow webhook (team-specific).

## Local / cron on server

```powershell
$env:PRODUCTION_WEB_BASE_URL = "https://ipnote.ir"
.\scripts\uptime-check.ps1 -IncludeProduction -RequireTls
```

Exit code `1` = failure (suitable for cron alerting).

## External monitors

Complement GitHub with an external ping (e.g. UptimeRobot, Better Stack) on:

- `https://<prod>/health`
- `https://<prod>/api/v1/IpLookup/GetMyIp`

## Related

- [on-call.md](on-call.md)
- [staging-smoke.md](staging-smoke.md)
- [observability-baseline.md](../observability/observability-baseline.md)
