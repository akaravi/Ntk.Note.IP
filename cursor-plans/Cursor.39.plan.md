# Cursor Plan — Ntk.Note.IP (Stage S9 batch 2)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 39",
    "updatedAt": "2026-05-30T22:30:00+03:30",
    "previousPart": "Cursor.38.plan.md"
  },
  "Part 39": {
    "title": "Stage S9 — docker-compose, migration CI, Trivy",
    "goal": "S9-006/014/021: compose prod sample; idempotent migration script in CI; Trivy on Docker image"
  },
  "Result 39": {
    "summary": "docker-compose.prod.yml + Dockerfile.migrate; verify-migrations.ps1 + migrate-idempotent.ps1; build.yml migration verify + SQL artifact; docker-image.yml Trivy; publish-api docker+Trivy on tags.",
    "artifacts": {
      "compose": "docker-compose.prod.yml",
      "migrateDocker": "Dockerfile.migrate",
      "scripts": ["verify-migrations.ps1", "migrate-idempotent.ps1"],
      "ci": ["build.yml migrations", "docker-image.yml", "publish-api.yml docker job"]
    },
    "deferred": ["PostgreSQL compose service when Npgsql 10 stable", "Testcontainers PG job"],
    "verification": {
      "verifyMigrations": "pass (SQLite)",
      "migrateScript": "artifacts/migrate-idempotent.sql (standard -i fallback on SQLite)",
      "build": "build.ps1 green"
    },
    "nextStage": "S9 batch 3: post-deploy smoke in CD or Redis in compose"
  }
}
```
