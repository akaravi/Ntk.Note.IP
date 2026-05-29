# Cursor Plan — Ntk.Note.IP (Stage S8 batch 1)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S8",
    "part": "Part 33",
    "updatedAt": "2026-05-30T14:30:00+03:30",
    "previousPart": "Cursor.32.plan.md"
  },
  "Part 33": {
    "title": "Stage S8 — IP edge-case tests, verify-all script, dev runbook",
    "goal": "S8-012 scope tests; S8-007 functional scope; run-verify-all.ps1; local-dev-stack runbook"
  },
  "Result 33": {
    "summary": "Extended IpAddressTests (CGNAT, link-local, ULA IPv6, 172.16/31); IpLookup functional scope test; scripts/run-verify-all.ps1 (flutter-ci + build + health + URL list); docs/runbooks/local-dev-stack.md.",
    "tests": {
      "domainAdded": ["Cgnat", "LinkLocal", "UniqueLocal", "172.16-31 private", "empty input"],
      "functionalAdded": "ShouldClassifySpecialScopesInIpDetails"
    },
    "ops": {
      "script": "scripts/run-verify-all.ps1",
      "runbook": "docs/runbooks/local-dev-stack.md"
    },
    "verification": {
      "build": "pass after stopping Ntk.Note.IP.Web (file lock)",
      "dotnetTests": "60 passed (3 arch + 13 domain + 18 app unit + 26 functional)",
      "flutterCi": "pass",
      "health": "http://localhost:5000/health, /alive, /health/ready, GetMyIp 200"
    },
    "deferred": [
      "S8-002 coverlet gate in CI",
      "S8-009 Playwright E2E",
      "S8-017 k6 load tests",
      "S8-010 Flutter integration tests beyond widget smoke"
    ],
    "nextStage": "S8 batch 2: Playwright smoke or coverlet CI gate"
  }
}
```
