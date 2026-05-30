# Cursor Plan — Ntk.Note.IP (Stage S9 batch 8)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 45",
    "updatedAt": "2026-05-30T07:00:00+03:30",
    "previousPart": "Cursor.44.plan.md"
  },
  "Part 45": {
    "title": "Stage S9 — uptime workflow + on-call + Hangfire prod notes",
    "goal": "S9-034/043/052: scheduled external health checks; incident runbook; Hangfire memory storage documented"
  },
  "Result 45": {
    "summary": "uptime-check.ps1; uptime-monitor.yml (cron */15); on-call.md; uptime-monitoring.md; background-jobs-production.md.",
    "ci": "uptime-monitor.yml → STAGING_WEB_BASE_URL + PRODUCTION_WEB_BASE_URL",
    "scripts": "scripts/uptime-check.ps1",
    "docs": [
      "docs/runbooks/on-call.md",
      "docs/runbooks/uptime-monitoring.md",
      "docs/runbooks/background-jobs-production.md"
    ],
    "deferred": [
      "Slack/PagerDuty webhook on uptime failure",
      "Hangfire PostgreSQL storage implementation",
      "Public status page (S9-050)"
    ],
    "nextStage": "S9 batch 9: S9 stage close checklist + plan.prompt alignment; or status page stub"
  }
}
```
