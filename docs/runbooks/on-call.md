# On-call and incident response

## Severity

| Level | Examples | Response |
|-------|----------|----------|
| S1 | Production down, data loss risk | Immediate; all hands |
| S2 | Degraded API, auth broken | < 30 min acknowledge |
| S3 | Non-critical feature, staging only | Next business day |

## First 15 minutes

1. Confirm scope: run `.\scripts\uptime-check.ps1` or check **Uptime monitor** workflow in GitHub Actions.
2. Check `/health`, `/health/ready`, `/alive` on affected URL ([observability-baseline.md](../observability/observability-baseline.md)).
3. Review host logs and recent deploy (image tag, migrations).
4. If bad deploy: [rollback.md](rollback.md) — previous GHCR tag or DB restore [database-backup.md](database-backup.md).

## Escalation

| Role | Responsibility |
|------|----------------|
| Primary on-call | Triage, rollback decision, comms |
| Platform / DevOps | Infra, TLS, DNS, compose/k8s |
| App owner | Application bugs, hotfix PR |

Document incident channel (Slack/Teams) and phone tree in your team wiki.

## Common failures

| Symptom | Likely cause | Action |
|---------|--------------|--------|
| `/health/ready` 503 | DB or Redis down | Check connection strings; restore DB volume |
| 502 from proxy | Web container stopped | `docker compose ps`; restart `web` |
| 429 everywhere | Rate limit / attack | Review `RateLimiting` config; WAF at edge |
| Jobs not running | Hangfire restart (memory storage) | See [background-jobs-production.md](background-jobs-production.md) |

## After resolution

1. Run `.\scripts\staging-smoke.ps1` or production URL smoke.
2. Note root cause and follow-up ticket.
3. Update [readmehistory.md](../../readmehistory.md) if config/runbook changed.

## Related

- [uptime-monitoring.md](uptime-monitoring.md)
- [cd-release.md](cd-release.md)
- [security-baseline.md](../security/security-baseline.md)
