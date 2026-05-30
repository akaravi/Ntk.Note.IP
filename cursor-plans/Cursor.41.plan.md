# Cursor Plan — Ntk.Note.IP (Stage S9 batch 4)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S9",
    "part": "Part 41",
    "updatedAt": "2026-05-30T01:15:00+03:30",
    "previousPart": "Cursor.40.plan.md"
  },
  "Part 41": {
    "title": "Stage S9 — staging URL smoke (workflow_dispatch)",
    "goal": "S9-041/042: smoke deployed staging/prod URL without local Docker; CI manual dispatch + secret"
  },
  "Result 41": {
    "summary": "staging-smoke.ps1; staging-smoke.yml (workflow_dispatch, STAGING_WEB_BASE_URL); post-deploy-smoke URL normalize + SkipSpa + RequireTls; runbook staging-smoke.md.",
    "scripts": {
      "stagingSmoke": "scripts/staging-smoke.ps1",
      "postDeployEnhancements": "scripts/post-deploy-smoke.ps1 (trim URL, SkipSpa, RequireTls)"
    },
    "ci": ".github/workflows/staging-smoke.yml",
    "docs": "docs/runbooks/staging-smoke.md",
    "secrets": ["STAGING_WEB_BASE_URL (optional repo secret)"],
    "deferred": [
      "Auto-dispatch staging smoke after publish-api tag",
      "PostgreSQL compose",
      "DAST/ZAP on staging",
      "Hangfire persistent storage prod"
    ],
    "nextStage": "S9 batch 5: CD manual approval gate or publish-api post-release hook; resource limits in compose"
  }
}
```
