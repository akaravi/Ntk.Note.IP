# Cursor Plan — Ntk.Note.IP (Stage S9 batch 1)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 38",
    "updatedAt": "2026-05-30T21:00:00+03:30",
    "previousPart": "Cursor.37.plan.md"
  },
  "Part 38": {
    "title": "Stage S9 — Production hardening + Docker + publish CI",
    "goal": "S9-003/004/011/015/023: prod config, health, no public OpenAPI UI, Dockerfile, publish workflow"
  },
  "Result 38": {
    "summary": "Production: health all envs, ForwardedHeaders, Scalar/OpenAPI dev-only; appsettings.Production expanded; Dockerfile + .dockerignore; publish-api.ps1 + publish-api.yml; ProductionHardeningApiTests; production-deploy runbook.",
    "artifacts": {
      "docker": "Dockerfile (port 8080)",
      "publish": "scripts/publish-api.ps1",
      "ci": ".github/workflows/publish-api.yml"
    },
    "deferred": [
      "Trivy image scan",
      "Helm/k8s manifests",
      "Hangfire persistent storage in prod",
      "CDN + blue-green"
    ],
    "verification": {
      "functional": "31 passed",
      "build": "build.ps1 green"
    },
    "nextStage": "S9 batch 2: docker-compose prod sample or migration CI step"
  }
}
```
