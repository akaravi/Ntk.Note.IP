# Cursor Plan — Ntk.Note.IP (Post-S9 Part 48)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 48",
    "updatedAt": "2026-05-30T11:30:00+03:30",
    "previousPart": "Cursor.47.plan.md"
  },
  "Part 48": {
    "title": "PostgreSQL CI verify + pg_dump backup script",
    "goal": "CI migration path on PostgreSQL; operational pg_dump backup; provider unit tests"
  },
  "Result 48": {
    "summary": "verify-migrations-postgresql.ps1; backup-database-postgresql.ps1; postgresql-migrations.yml; DatabaseProviderConfigurationTests; docs updated.",
    "ci": {
      "workflow": "postgresql-migrations.yml",
      "artifact": "migrate-idempotent-postgresql-sql"
    },
    "scripts": {
      "verifyPg": "scripts/verify-migrations-postgresql.ps1",
      "backupPg": "scripts/backup-database-postgresql.ps1"
    },
    "tests": "DatabaseProviderConfigurationTests (5 cases)",
    "deferred": [
      "Testcontainers in functional tests",
      "Hangfire distributed lock multi-replica",
      "Merge PG job into build.yml (kept separate for path filters)"
    ],
    "nextStage": "Product v1 / deep link / or run-all validation"
  }
}
```
