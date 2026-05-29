# Cursor Plan — Ntk.Note.IP (Stage S9 batch 6)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 43",
    "updatedAt": "2026-05-30T04:00:00+03:30",
    "previousPart": "Cursor.42.plan.md"
  },
  "Part 43": {
    "title": "Stage S9 — GHCR publish + deploy environment workflows",
    "goal": "S9-007/036: push image on tag; deploy-staging/production with GitHub Environments; registry compose overlay"
  },
  "Result 43": {
    "summary": "publish-api pushes to ghcr.io/OWNER/REPO/ipnote-web on tag; deploy-staging.yml + deploy-production.yml; docker-compose.prod.registry.yml; container-registry + ENVIRONMENTS docs.",
    "registry": {
      "image": "ghcr.io/<owner>/<repo>/ipnote-web",
      "pushOnTag": true,
      "manualPush": "publish-api workflow_dispatch push_to_registry"
    },
    "workflows": ["deploy-staging.yml", "deploy-production.yml"],
    "secrets": ["STAGING_WEB_BASE_URL", "PRODUCTION_WEB_BASE_URL"],
    "deferred": [
      "SSH/k8s deploy automation on host",
      "migrate image to GHCR",
      "Blue-green / Helm",
      "PostgreSQL compose"
    ],
    "nextStage": "S9 batch 7: observability baseline (health metrics export doc) or backup runbook"
  }
}
```
