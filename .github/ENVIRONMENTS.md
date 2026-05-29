# GitHub Environments

Configure in **Settings → Environments** for deploy approval gates.

## `staging`

- Used by: `deploy-staging.yml`
- Optional: required reviewers for team sign-off before deploy instructions run
- Secret: `STAGING_WEB_BASE_URL` — post-deploy smoke target

## `production`

- Used by: `deploy-production.yml`
- Recommended: **required reviewers** (manual CD gate, S9-036)
- Secret: `PRODUCTION_WEB_BASE_URL` — smoke after production deploy

## Package permissions

**Publish API** pushes to GHCR using `GITHUB_TOKEN` with `packages: write`. For private repos, grant the deploying host a PAT with `read:packages`.

See [docs/runbooks/container-registry.md](../docs/runbooks/container-registry.md).

## Uptime

Workflow `uptime-monitor.yml` reads `STAGING_WEB_BASE_URL` and `PRODUCTION_WEB_BASE_URL` every 15 minutes. Configure repo notifications for failed runs.
