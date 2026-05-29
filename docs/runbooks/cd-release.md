# CD release pipeline

## Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `build.yml` | PR / push `main` | Build, tests, coverage ≥40%, migrations verify, gitleaks |
| `docker-image.yml` | PR (Docker paths) | Trivy + compose post-deploy smoke |
| `publish-api.yml` | Tag `v*.*.*` or manual | `dotnet publish` artifact + Docker build/push GHCR + Trivy |
| `staging-smoke.yml` | Manual or called from publish | Health/API/SPA smoke on deployed URL |
| `deploy-staging.yml` | Manual | Environment `staging` + deploy summary + smoke |
| `deploy-production.yml` | Manual | Environment `production` + deploy summary + smoke |
| `load-smoke.yml` | PR / manual | k6 against ephemeral local API |
| `uptime-monitor.yml` | Cron 15 min / manual | External health probe via secrets |
| `postgresql-migrations.yml` | PR (Infrastructure paths) | EF migrate on PostgreSQL 16 service |

## Release flow (recommended)

1. Merge to `main` with green CI.
2. Tag: `git tag v1.2.3 && git push origin v1.2.3`
3. **Publish API** runs: publish artifact, push `ghcr.io/<owner>/<repo>/ipnote-web:v1.2.3`, Trivy scan.
4. **Deploy staging** or pull image on host (see [container-registry.md](container-registry.md)).
5. **Staging smoke** (automatic on tag if `STAGING_WEB_BASE_URL` is set).
6. **Deploy production** (manual, environment approval) when ready.

### Manual publish with smoke

Actions → **Publish API** → Run workflow:

- **run_staging_smoke:** true
- **staging_base_url:** optional override

Requires secret `STAGING_WEB_BASE_URL` unless you pass a full URL in **staging_base_url**.

## Production approval (manual gate)

Workflow **Deploy production** uses `environment: production`.

1. Create environment: Settings → Environments → `production` → Required reviewers.
2. Set secret `PRODUCTION_WEB_BASE_URL`.
3. Run workflow with image tag after staging smoke passes.

See [.github/ENVIRONMENTS.md](../../.github/ENVIRONMENTS.md).

## Resource limits (compose)

`docker-compose.prod.yml` sets `mem_limit` / `cpus` on `web` and `migrate`; Redis overlay adds limits + healthcheck. Image `HEALTHCHECK` uses `/health`.

## Related

- [production-deploy.md](production-deploy.md)
- [staging-smoke.md](staging-smoke.md)
- [rollback.md](rollback.md)
- [database-backup.md](database-backup.md)
- [observability-baseline.md](../observability/observability-baseline.md)
- [uptime-monitoring.md](uptime-monitoring.md)
- [on-call.md](on-call.md)
- [background-jobs-production.md](background-jobs-production.md)
- [status-page.md](status-page.md)
- [s9-stage-close-checklist.md](../devops/s9-stage-close-checklist.md)
