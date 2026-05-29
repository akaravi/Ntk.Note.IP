# Cursor Plan — Ntk.Note.IP (LastRunInfo.html)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 72",
    "updatedAt": "2026-05-29T21:45:00+03:30",
    "previousPart": "Cursor.71.plan.md"
  },
  "Part 72": {
    "title": "LastRunInfo.html after port allocation / run-all",
    "goal": "After run-all completes, generate LastRunInfo.html at repo root with three tables: execution results, service URLs, port allocation",
    "rule": "Every run-all.ps1 / restart-all.ps1 writes or updates LastRunInfo.html via write-last-run-info.ps1",
    "files": [
      "scripts/write-last-run-info.ps1",
      "scripts/local-dev-ports.ps1 (Get-IpNotePortAllocationRows, Get-IpNoteDevServiceUrlRows)",
      "scripts/run-all.ps1 (Add-RunResult + Complete-RunAll)",
      "docs/runbooks/local-dev-run-all.md",
      "docs/runbooks/local-dev-ports.md",
      ".gitignore (LastRunInfo.html)"
    ],
    "tables": {
      "executionResults": "نتیجه اجرا — steps 1-7 with OK/SKIP/FAIL/WARN",
      "serviceUrls": "آدرس‌های سرویس — API, dashboard, health, logs, Flutter",
      "portAllocation": "تخصیص پورت‌ها — 5340-5349 from IpNoteDevPorts"
    }
  },
  "Result 72": {
    "summary": "LastRunInfo.html generated at repo root on every run-all completion (success, partial, or failure). Theme-aware RTL HTML with light/dark via prefers-color-scheme. Gitignored.",
    "outputPath": "LastRunInfo.html",
    "triggerScripts": ["scripts/run-all.ps1", "scripts/restart-all.ps1"]
  }
}
```
