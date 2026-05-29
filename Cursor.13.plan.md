# Cursor Plan — Ntk.Note.IP (run all + hotfix)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 13",
    "updatedAt": "2026-05-29T21:00:00+03:30",
    "previousPart": "Cursor.12.plan.md"
  },
  "Part 13": {
    "title": "run all — Aspire, health, endpoint hotfix",
    "goal": "Execute stack; fix blocking errors; document URLs"
  },
  "Result 13": {
    "summary": "build.ps1 72 tests green; AppHost runs without Docker; duplicate endpoint names fixed; health/API verified.",
    "fixes": {
      "appHostRedis": "Redis container optional via IPNOTE_USE_REDIS_CONTAINER=true (requires Docker)",
      "duplicateEndpoints": "Renamed handler methods (GetListIpLookupRecords, GetListIpNotes, GetListBlacklist, etc.) for unique OpenAPI operationIds",
      "runAllScript": "scripts/run-all.ps1"
    },
    "runAll": {
      "aspireDashboard": "http://ntk.note.ip.dev.localhost:15000",
      "webApiSession": "http://127.0.0.1:54433 (dynamic port per run)",
      "health": { "/health": 200, "/health/ready": 200, "/alive": 200 },
      "apiSample": "GET /api/IpLookup/GetMyIp -> 200",
      "ssl": "HTTP profile only in Aspire run; HTTPS not bound on dynamic port",
      "redis": "Skipped (no Docker); memory cache active",
      "angular": "Started via Aspire JavaScript app (check dashboard for webfrontend URL)"
    },
    "tests": { "totalPipeline": 72 },
    "nextStage": "Install Docker for Redis container or continue S4 migrations"
  }
}
```
