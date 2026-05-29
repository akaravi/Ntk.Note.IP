# Stage S9 (DevOps) — close checklist

**Goal (plan):** CI/CD, production deploy path, monitoring hooks, operational runbooks.  
**Status:** Core track delivered in Parts 38–46 (`Cursor.38` … `Cursor.46`). Items below marked **Done**, **Partial**, or **Deferred**.

## CI / quality gates

| Item | Status | Evidence |
|------|--------|----------|
| Build + unit/functional tests | Done | `build.yml`, `build.ps1` |
| Coverage ≥40% | Done | `coverlet.runsettings`, CI gate |
| gitleaks (informational) | Done | `build.yml` |
| Migration verify + SQL artifact | Done | `verify-migrations.ps1`, CI |
| Playwright E2E | Done | `run-e2e.ps1`, acceptance tests |
| k6 load smoke (CI) | Done | `load-smoke.yml` |
| Docker Trivy + compose smoke | Done | `docker-image.yml` |

## Release & deploy

| Item | Status | Evidence |
|------|--------|----------|
| `dotnet publish` artifact | Done | `publish-api.ps1`, `publish-api.yml` |
| Multi-stage Dockerfile + HEALTHCHECK | Done | `Dockerfile` |
| docker-compose prod (+ Redis overlay) | Done | `docker-compose.prod*.yml` |
| GHCR push on tag | Done | `publish-api.yml` |
| Registry pull overlay | Done | `docker-compose.prod.registry.yml` |
| Staging / production deploy workflows | Done | `deploy-staging.yml`, `deploy-production.yml` |
| Post-deploy / staging smoke | Done | `post-deploy-smoke.ps1`, `staging-smoke.yml` |
| Rollback runbook | Done | `rollback.md` |

## Security & production hardening

| Item | Status | Evidence |
|------|--------|----------|
| ForwardedHeaders, HSTS | Done | `Program.cs`, `ProductionHardeningApiTests` |
| Scalar/OpenAPI dev-only | Done | `Program.cs` |
| Security headers middleware | Done | S8 `SecurityHeadersMiddleware` |
| Rate limiting | Done | `GuestApi`, `AuthSensitive` |
| `security-baseline.md` | Done | `docs/security/` |

## Observability & uptime

| Item | Status | Evidence |
|------|--------|----------|
| Health `/health`, `/alive`, `/health/ready` | Done | `ServiceDefaults`, Infrastructure checks |
| Prometheus `/metrics` (opt-in) | Done | `OpenTelemetry:EnablePrometheusEndpoint` |
| OTLP traces/metrics doc | Done | `observability-baseline.md` |
| Prometheus/Grafana compose sample | Done | `docker-compose.observability.yml` |
| Uptime workflow (15 min) | Done | `uptime-monitor.yml` |
| Public status page stub | Done | `/status.html` |
| Deep link verification files | Partial | `/.well-known/*` — replace TEAMID / SHA256 before prod |
| Public changelog page | Done | `/changelog.html` + `CHANGELOG.md` |
| Full Prometheus/Grafana in prod | Deferred | Team infra |
| Sentry / DAST ZAP | Deferred | S8/S9 plan |

## Data & jobs

| Item | Status | Evidence |
|------|--------|----------|
| SQLite backup scripts | Done | `backup-database.ps1` |
| PostgreSQL prod DB | Done | Npgsql 10.0.2, `docker-compose.prod.postgresql.yml` |
| Hangfire persistent storage | Partial | PostgreSQL when PG provider; Memory on Sqlite |
| Hangfire dashboard prod | N/A (intentionally dev-only) | `Program.cs` |

## Operations

| Item | Status | Evidence |
|------|--------|----------|
| CD release doc | Done | `cd-release.md` |
| On-call runbook | Done | `on-call.md` |
| Container registry doc | Done | `container-registry.md` |
| GitHub Environments guide | Done | `.github/ENVIRONMENTS.md` |

## Sign-off (fill when Go-Live)

- [ ] `STAGING_WEB_BASE_URL` / `PRODUCTION_WEB_BASE_URL` secrets set
- [ ] Tag `v*.*.*` published to GHCR and deployed
- [ ] Staging + production smoke green
- [ ] Uptime workflow enabled and notifications configured
- [ ] Backup schedule active on production DB volume
- [ ] Stakeholder Go-Live (plan S9-089)

## Related

- [status-page.md](../runbooks/status-page.md)
- [cd-release.md](../runbooks/cd-release.md)
- `plan.prompt/IPNote.plan.md` Part 10 (S9 full 100 items)
