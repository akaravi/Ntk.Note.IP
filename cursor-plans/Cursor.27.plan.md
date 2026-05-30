# Cursor Plan — Ntk.Note.IP (Stage S7 batch 2)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 27",
    "updatedAt": "2026-05-30T08:30:00+03:30",
    "previousPart": "Cursor.26.plan.md"
  },
  "Part 27": {
    "title": "Stage S7 — Theme/locale prefs, Bearer login, dashboard guard",
    "goal": "S7-011..014 subset: persisted theme/locale, Vazirmatn fa, go_router /login /dashboard redirect, POST Users/login Bearer"
  },
  "Result 27": {
    "summary": "SettingsRepository + SettingsController (theme cycle, locale toggle); AuthTokenStore + login screen; Dio Bearer interceptor; dashboard placeholder with AuthGuard redirect; google_fonts Vazirmatn.",
    "flutter": {
      "settings": ["shared_preferences locale + theme_mode", "AppBar translate/brightness icons"],
      "auth": {
        "login": "POST /api/v1/Users/login (no cookies)",
        "storage": "shared_preferences access/refresh",
        "interceptor": "Authorization Bearer on apiClientProvider",
        "routes": ["/", "/login", "/dashboard"]
      },
      "fonts": "google_fonts Vazirmatn when locale fa",
      "l10nKeysAdded": 12
    },
    "quality": {
      "dartAnalyze": "no issues",
      "flutterTest": "1 passed (settings override + SharedPreferences mock)"
    },
    "deferred": [
      "S7-016 local IP",
      "S7-017 QR",
      "S7-022 Drift/Hive history",
      "S7-024 full dashboard",
      "flutter_secure_storage",
      "S7-006 OpenAPI codegen"
    ],
    "nextStage": "S7 batch 3: IP lookup detail, map, ISP cards, ActionLookup on open"
  }
}
```
