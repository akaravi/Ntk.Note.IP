# Cursor Plan — Ntk.Note.IP (Stage S8 batch 2)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S8",
    "part": "Part 34",
    "updatedAt": "2026-05-30T15:45:00+03:30",
    "previousPart": "Cursor.33.plan.md"
  },
  "Part 34": {
    "title": "Stage S8 — Playwright E2E IP lookup + login fix",
    "goal": "S8-009: E2E مسیر IP→تاریخچه؛ حذف تست‌های قالب Counter/Home؛ run-e2e.ps1"
  },
  "Result 34": {
    "summary": "Playwright/Reqnroll: IpLookup.feature (My IP + lookup→history); data-testid on ip-lookup + nav-logout; Login uses nav-logout; removed template Home/Counter; scripts/run-e2e.ps1; run-verify-all -IncludeE2e.",
    "e2e": {
      "features": ["IpLookup (2 scenarios)", "Login (2 scenarios)"],
      "script": "scripts/run-e2e.ps1"
    },
    "angular": {
      "testIds": ["ip-lookup-page", "my-ip-address", "ip-address-input", "ip-lookup-submit", "ip-history-section", "ip-history-item", "nav-logout"]
    },
    "verification": {
      "e2e": "4 passed (2 IpLookup + 2 Login)",
      "fixes": ["localStorage clear after navigation", "My IP regex IPv4|IPv6", "BeforeScenario scoped to @IpLookup removed"]
    },
    "deferred": ["S8-002 coverlet CI gate", "S8-017 k6", "Dashboard E2E"]
  }
}
```
