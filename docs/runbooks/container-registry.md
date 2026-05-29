# Container registry (GHCR)

## Image coordinates

Published on tag `v*.*.*` by **Publish API** workflow:

```text
ghcr.io/<owner>/<repo>/ipnote-web:<tag>
```

Example (this repository):

```text
ghcr.io/akaravi/ntk.note.ip/ipnote-web:v1.2.3
```

Also tagged with semver (`1.2.3`, `1.2`) when pushing from a version tag.

## Pull on server

```bash
docker login ghcr.io
docker pull ghcr.io/akaravi/ntk.note.ip/ipnote-web:v1.2.3
```

For private packages, use a GitHub PAT with `read:packages` on the server.

## Compose with registry image

```bash
export IPNOTE_WEB_IMAGE=ghcr.io/akaravi/ntk.note.ip/ipnote-web:v1.2.3
docker compose -f docker-compose.prod.yml -f docker-compose.prod.registry.yml up -d
```

`docker-compose.prod.registry.yml` clears the local `web` build (`build: !reset null`) and pulls `IPNOTE_WEB_IMAGE`.

## CI

| Event | Push to GHCR |
|-------|----------------|
| Tag `v*.*.*` | Yes (after Trivy) |
| Manual **Publish API** | Only if **push_to_registry** is true |

Package visibility: GitHub repo **Packages** → `ipnote-web` → set public or grant access.

## Deploy workflows

| Workflow | Environment | Purpose |
|----------|-------------|---------|
| `deploy-staging.yml` | `staging` | Manual approval + deploy instructions + optional smoke |
| `deploy-production.yml` | `production` | Manual approval + deploy instructions + optional smoke |

Create environments under **Settings → Environments** and add required reviewers for `production` (and optionally `staging`).

Secrets:

| Secret | Used by |
|--------|---------|
| `STAGING_WEB_BASE_URL` | Staging smoke, deploy-staging |
| `PRODUCTION_WEB_BASE_URL` | deploy-production smoke |

## Related

- [cd-release.md](cd-release.md)
- [production-deploy.md](production-deploy.md)
