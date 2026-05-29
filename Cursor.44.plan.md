# Cursor Plan — Ntk.Note.IP (Stage S9 batch 7)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 44",
    "updatedAt": "2026-05-30T05:30:00+03:30",
    "previousPart": "Cursor.43.plan.md"
  },
  "Part 44": {
    "title": "Stage S9 — backup runbook + observability baseline",
    "goal": "S9-027/029: SQLite backup scripts; Prometheus /metrics opt-in; OTLP doc; compose observability overlay"
  },
  "Result 44": {
    "summary": "backup-database.ps1, restore-database.ps1; database-backup.md; observability-baseline.md; OpenTelemetry Prometheus exporter + /metrics; docker-compose.observability.yml; PrometheusMetricsApiTests.",
    "code": {
      "prometheus": "OpenTelemetry:EnablePrometheusEndpoint → MapPrometheusScrapingEndpoint /metrics",
      "package": "OpenTelemetry.Exporter.Prometheus.AspNetCore 1.11.0-beta.1"
    },
    "ops": {
      "backupScript": "scripts/backup-database.ps1",
      "observabilityCompose": "docker-compose.observability.yml"
    },
    "tests": "PrometheusMetricsApiTests (2)",
    "deferred": [
      "Automated scheduled backup workflow on host",
      "PostgreSQL pg_dump automation",
      "OpenTelemetry Collector sidecar in prod compose",
      "Sentry / external APM wiring"
    ],
    "nextStage": "S9 batch 8: uptime workflow or on-call runbook; Hangfire persistent storage note"
  }
}
```
