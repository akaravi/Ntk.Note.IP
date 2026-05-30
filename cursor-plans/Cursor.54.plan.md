# Cursor Plan — Ntk.Note.IP (Post-S9 Part 54)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 54",
    "updatedAt": "2026-05-30T18:00:00+03:30",
    "previousPart": "Cursor.53.plan.md"
  },
  "Part 54": {
    "title": "Drift offline IP history (S7-022)",
    "goal": "Replace SharedPreferences JSON blob with SQLite via Drift; one-time legacy migration; appDatabaseProvider; unit tests"
  },
  "Result 54": {
    "summary": "AppDatabase + IpHistoryRows table; IpHistoryStore backed by Drift; migrateLegacyIpHistoryIfNeeded from prefs; schema v2; ip_history_store_test with in-memory DB.",
    "paths": {
      "database": "lib/core/history/database/app_database.dart",
      "migration": "lib/core/history/ip_history_legacy_migration.dart",
      "store": "lib/core/history/ip_history_store.dart"
    },
    "deferred": [
      "Background IP change monitor (workmanager)",
      "Retrofit client migration"
    ],
    "nextStage": "Background IP monitor or product backlog"
  }
}
```
