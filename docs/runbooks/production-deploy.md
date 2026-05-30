# Production deployment runbook

## Prerequisites

- PostgreSQL connection string (`ConnectionStrings:IPNoteDb`) and `Database:Provider=PostgreSQL` (see [ADR-006](../decisions/ADR-006-PostgreSQL-Production-Database.md))
- Secrets: JWT signing key, optional Azure Key Vault (`AZURE_KEY_VAULT_ENDPOINT`)
- Reverse proxy (Nginx/Caddy/Traefik) terminating TLS and forwarding `X-Forwarded-For` / `X-Forwarded-Proto`
- CORS origins in `appsettings.Production.json` or environment overrides

## Build publish folder

```powershell
.\scripts\publish-api.ps1 -Configuration Release
# output: publish\dotnet\web
```

Includes Angular production build via `Web.csproj` publish target.

## Docker image

From GHCR (after tag publish):

```bash
docker pull ghcr.io/akaravi/ntk.note.ip/ipnote-web:v1.2.3
docker run -d -p 8080:8080 \
  ghcr.io/akaravi/ntk.note.ip/ipnote-web:v1.2.3
```

Or build locally:

```bash
docker build -t ipnote-web:latest .
docker run -d -p 8080:8080 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e ConnectionStrings__IPNoteDb="Host=...;Database=ipnote;..." \
  -e Database__Provider=PostgreSQL \
  ipnote-web:latest
```

### docker-compose (single server, SQLite volume)

Runs one-shot migrations then the Web container:

```bash
docker compose -f docker-compose.prod.yml up --build -d
curl http://localhost:8080/health
```

With Redis cache overlay:

```bash
docker compose -f docker-compose.prod.yml -f docker-compose.prod.redis.yml up --build -d
```

With PostgreSQL (recommended for multi-instance / production):

```bash
docker compose -f docker-compose.prod.yml -f docker-compose.prod.postgresql.yml up --build -d
# optional: -f docker-compose.prod.redis.yml
```

Local full smoke (compose + health + SPA; optional k6 if installed):

```powershell
.\scripts\run-docker-prod-smoke.ps1
# keep stack running:
.\scripts\run-docker-prod-smoke.ps1 -KeepRunning -WithRedis
```

Post-deploy checks only:

```powershell
.\scripts\post-deploy-smoke.ps1 -WebBaseUrl http://localhost:8080
```

CI: Trivy + compose smoke on PRs (`.github/workflows/docker-image.yml`).

**Resource limits:** `web` 768m / 1.5 CPU, `migrate` 512m / 1 CPU; optional Redis overlay 256m / 0.5 CPU. Image includes `HEALTHCHECK` on `/health`.

**Release CD:** [cd-release.md](cd-release.md) — tag publish, optional post-release staging smoke. **Rollback:** [rollback.md](rollback.md).

Probe URLs:

| Probe | Path |
|-------|------|
| Liveness | `/alive` |
| Readiness | `/health/ready` |
| General | `/health` |

## Database migrations

Run before first deploy and on each release (idempotent):

```bash
dotnet ef database update --project src/Infrastructure --startup-project src/Web
```

Or generate SQL script for DBA review:

```bash
dotnet ef migrations script -i --project src/Infrastructure --startup-project src/Web -o artifacts/migrate.sql
```

Migration SQL script (CI artifact `migrate-idempotent-sql`; uses `--idempotent` on PostgreSQL/SQL Server, standard `-i` script on SQLite):

```powershell
.\scripts\migrate-idempotent.ps1
```

Verify migrations apply to a fresh SQLite file (also runs in CI):

```powershell
.\scripts\verify-migrations.ps1
```

## Production behaviour

- **Scalar / OpenAPI:** disabled (Development only)
- **Hangfire dashboard:** Development only; background jobs still run via Hangfire server
- **Health:** enabled in all environments (restrict at network edge)
- **Forwarded headers:** enabled when not Development (behind reverse proxy)
- **HSTS:** enabled when not Development

## Post-deploy smoke

**Local / compose:** `post-deploy-smoke.ps1` or `run-docker-prod-smoke.ps1` (see above).

**Staging or production URL:** [staging-smoke.md](staging-smoke.md) and GitHub workflow `staging-smoke.yml`.

```powershell
.\scripts\staging-smoke.ps1 -WebBaseUrl https://staging.ipnote.ir -RequireTls
.\scripts\verify-health.ps1 -WebBaseUrl https://api.ipnote.ir
.\scripts\run-k6-smoke.ps1 -BaseUrl https://api.ipnote.ir
```

## Observability and backup

- Metrics/traces: [observability-baseline.md](../observability/observability-baseline.md) — enable `OpenTelemetry__EnablePrometheusEndpoint` for `/metrics`; optional `docker-compose.observability.yml`.
- DB backup: [database-backup.md](database-backup.md) — `scripts/backup-database.ps1` / `restore-database.ps1`.
- Hangfire jobs: [background-jobs-production.md](background-jobs-production.md) — memory storage limits; dashboard dev-only.
- Incidents: [on-call.md](on-call.md); uptime: [uptime-monitoring.md](uptime-monitoring.md).

## Related

- [security-baseline.md](../security/security-baseline.md)
- [local-dev-stack.md](local-dev-stack.md)
- [ADR-006 PostgreSQL](../decisions/ADR-006-PostgreSQL-Production-Database.md)
