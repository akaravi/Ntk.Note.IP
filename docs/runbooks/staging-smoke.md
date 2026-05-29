# Staging smoke runbook

Smoke checks against a **deployed** environment (staging or production) without starting Docker locally.

## Local

Set the base URL (no trailing slash required):

```powershell
$env:STAGING_WEB_BASE_URL = "https://staging.ipnote.ir"
.\scripts\staging-smoke.ps1 -RequireTls
```

Or pass the URL explicitly:

```powershell
.\scripts\staging-smoke.ps1 -WebBaseUrl https://staging.ipnote.ir -RequireTls -WaitSeconds 90
```

API-only host (no Angular at `/`):

```powershell
.\scripts\staging-smoke.ps1 -WebBaseUrl https://api.staging.ipnote.ir -RequireTls -SkipSpa
```

Include k6 when installed:

```powershell
.\scripts\staging-smoke.ps1 -WebBaseUrl https://staging.ipnote.ir -RequireTls
# omit -SkipK6 on post-deploy-smoke via staging-smoke default (k6 runs if present)
```

Underlying script: `post-deploy-smoke.ps1` (health, optional SPA, optional k6).

## GitHub Actions

Workflow: **Staging smoke** (`.github/workflows/staging-smoke.yml`)

1. Add repository secret `STAGING_WEB_BASE_URL` (recommended), or pass **web_base_url** when dispatching.
2. Actions → Staging smoke → Run workflow.
3. Defaults: `require_tls=true`, `skip_k6=true` (enable k6 only when staging can handle load).

After a release:

- **Tag `v*.*.*`:** **Publish API** runs staging smoke automatically when repository secret `STAGING_WEB_BASE_URL` is set.
- Otherwise run **Staging smoke** manually or enable **run_staging_smoke** on a manual **Publish API** dispatch.

See [cd-release.md](cd-release.md).

## Checks performed

| Check | Path / note |
|-------|-------------|
| Health | `/health`, `/alive`, `/health/ready` |
| API sample | `/api/v1/IpLookup/GetMyIp` |
| SPA (optional) | `GET /` → 200 |
| k6 (optional) | `tests/load/smoke.js` |

## Related

- [production-deploy.md](production-deploy.md) — compose and local post-deploy smoke
- [load-testing.md](load-testing.md) — k6 thresholds
- [security-baseline.md](../security/security-baseline.md)
