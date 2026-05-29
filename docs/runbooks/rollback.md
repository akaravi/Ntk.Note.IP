# Deployment rollback runbook

## Docker Compose (single server)

1. Note the previous GHCR tag (e.g. `v1.2.2`) or commit SHA used for the last good deploy.

```bash
export IPNOTE_WEB_IMAGE=ghcr.io/akaravi/ntk.note.ip/ipnote-web:v1.2.2
docker pull "$IPNOTE_WEB_IMAGE"
```
2. Stop the current stack:

```bash
docker compose -f docker-compose.prod.yml down
```

3. Check out or pull the previous release tag, rebuild, and start:

```bash
git checkout vX.Y.Z-previous
docker compose -f docker-compose.prod.yml up --build -d
```

4. Run smoke:

```powershell
.\scripts\post-deploy-smoke.ps1 -WebBaseUrl http://localhost:8080
```

Or against staging:

```powershell
.\scripts\staging-smoke.ps1 -WebBaseUrl https://staging.ipnote.ir -RequireTls
```

## Database

- Migrations are forward-only in normal releases. Roll back **application** first; only restore DB from backup if a migration caused data loss.
- Generate review script: `.\scripts\migrate-idempotent.ps1`
- Fresh verify: `.\scripts\verify-migrations.ps1`

## Published folder (non-Docker)

1. Redeploy the previous artifact from GitHub Actions **ipnote-web-publish** (tag run) or local `artifacts\publish\web` backup.
2. Restart the host process or IIS/Kestrel service.
3. Run `.\scripts\staging-smoke.ps1` against the public URL.

## CI / release tags

- New tag `v*.*.*` triggers **Publish API**. Fix forward with a patch tag; do not delete published tags in use.
- If post-release smoke fails, rollback deploy on the server then re-run **Staging smoke** workflow.

## Related

- [cd-release.md](cd-release.md)
- [production-deploy.md](production-deploy.md)
