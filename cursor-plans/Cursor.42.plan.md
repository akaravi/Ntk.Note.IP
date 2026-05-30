# Cursor Plan — Ntk.Note.IP (Stage S9 batch 5)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 42",
    "updatedAt": "2026-05-30T02:30:00+03:30",
    "previousPart": "Cursor.41.plan.md"
  },
  "Part 42": {
    "title": "Stage S9 — CD hook + compose limits + rollback runbook",
    "goal": "S9-022/025/036/037: publish-api post-release smoke; mem/CPU limits; HEALTHCHECK; operational rollback/CD docs"
  },
  "Result 42": {
    "summary": "publish-api.yml calls staging-smoke (tag+secret or dispatch); staging-smoke workflow_call; compose mem_limit/cpus/healthcheck; Dockerfile curl+HEALTHCHECK; cd-release + rollback runbooks.",
    "ci": {
      "publishApi": "staging-smoke job after docker when STAGING_WEB_BASE_URL or run_staging_smoke",
      "stagingSmoke": "workflow_call reusable"
    },
    "compose": {
      "web": "768m, 1.5 cpu, healthcheck, restart",
      "migrate": "512m, 1 cpu",
      "redis": "256m, 0.5 cpu, redis-cli ping"
    },
    "dockerfile": "curl + HEALTHCHECK /health",
    "docs": ["docs/runbooks/cd-release.md", "docs/runbooks/rollback.md"],
    "deferred": [
      "GitHub Environment production approval job on host deploy",
      "PostgreSQL compose",
      "Registry push job",
      "Blue-green / Helm"
    ],
    "nextStage": "S9 batch 6: container registry publish on tag; or GitHub environment deploy job template"
  }
}
```
