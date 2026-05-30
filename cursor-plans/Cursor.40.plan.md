# Cursor Plan — Ntk.Note.IP (Stage S9 batch 3)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 40",
    "updatedAt": "2026-05-30T23:45:00+03:30",
    "previousPart": "Cursor.39.plan.md"
  },
  "Part 40": {
    "title": "Stage S9 — post-deploy smoke + Redis compose overlay",
    "goal": "S9-041/026: smoke after deploy; docker-compose Redis optional; CI compose smoke"
  },
  "Result 40": {
    "summary": "post-deploy-smoke.ps1; run-docker-prod-smoke.ps1; docker-compose.prod.redis.yml; docker-image.yml post-deploy-smoke job.",
    "scripts": {
      "postDeploySmoke": "scripts/post-deploy-smoke.ps1",
      "dockerProdSmoke": "scripts/run-docker-prod-smoke.ps1"
    },
    "compose": {
      "redisOverlay": "docker-compose.prod.redis.yml"
    },
    "ci": "docker-image.yml: compose up + smoke + down",
    "ciExtras": "build.yml gitleaks job (informational)",
    "deferred": ["CD smoke against real staging URL", "PostgreSQL compose"],
    "nextStage": "S9 batch 4: staging URL workflow_dispatch smoke"
  }
}
```
