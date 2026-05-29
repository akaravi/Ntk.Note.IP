# Cursor Plan — Ntk.Note.IP (build orchestrator)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 66",
    "updatedAt": "2026-05-29T18:30:00+03:30",
    "previousPart": "Cursor.65.plan.md"
  },
  "Part 66": {
    "title": "Unified _build-all-projects.ps1",
    "goal": "Thesis-style full build script for solution, SPA, Flutter, release ZIP, and dev stack",
    "reference": "Karavi.Thesis.AudioSignalStealthLogisticChaosMapping.App/_build-all-projects.ps1"
  },
  "Result 66": {
    "summary": "Added root _build-all-projects.ps1; build.ps1 stops AppHost/Web before build unless -SkipStopRunningProjects.",
    "files": [
      "_build-all-projects.ps1",
      "build.ps1"
    ],
    "usage": {
      "dev": ".\\_build-all-projects.ps1 -SkipPackage",
      "releaseZip": ".\\_build-all-projects.ps1 -Configuration Release -NonInteractive",
      "buildOnly": ".\\_build-all-projects.ps1 -SkipPackage -SkipDevServers"
    }
  }
}
```
