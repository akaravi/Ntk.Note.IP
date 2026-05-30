# Cursor Plan — Ntk.Note.IP (Post-S9 Part 47)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 47",
    "updatedAt": "2026-05-30T10:00:00+03:30",
    "previousPart": "Cursor.46.plan.md"
  },
  "Part 47": {
    "title": "PostgreSQL provider + Hangfire PostgreSQL storage",
    "goal": "ADR-006 implementation: Npgsql EF 10; compose PG overlay; Hangfire.PostgreSql"
  },
  "Result 47": {
    "summary": "DatabaseProviderConfiguration (Sqlite/PostgreSQL); Npgsql 10.0.2; Hangfire.PostgreSql when PG; docker-compose.prod.postgresql.yml; appsettings.PostgreSQL.json; ADR-006 updated.",
    "packages": [
      "Npgsql.EntityFrameworkCore.PostgreSQL 10.0.2",
      "Hangfire.PostgreSql 1.21.1"
    ],
    "compose": "docker-compose.prod.postgresql.yml (postgres:16 + migrate/web env)",
    "deferred": [
      "CI Testcontainers PostgreSQL job",
      "Hangfire multi-replica distributed lock",
      "pg_dump automation script"
    ],
    "nextStage": "Post-S9: CI PG migration verify or product v1 features"
  }
}
```
