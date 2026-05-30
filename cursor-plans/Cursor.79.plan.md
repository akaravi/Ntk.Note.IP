{
  "metadata": {
    "title": "Cursor.79 — Flutter splash bootstrap timeout",
    "updatedAt": "2026-05-30"
  },
  "part79": {
    "tasks": [
      "Diagnose splash stuck: bootstrapReady required settings.hasValue forever",
      "Add authBootstrapTimeoutProvider (8s) to force leave splash",
      "SettingsRepository load timeout 5s with AppSettings.defaults fallback",
      "Lazy GoRouter watch only when _BootstrapStep.main",
      "Schedule/cancel bootstrap timers in post-frame + dispose",
      "Fix widget_test pending timer via timeout provider override",
      "Run flutter test"
    ]
  },
  "result79": {
    "status": "completed",
    "rootCause": "_isBootstrapReady required settings.hasValue; if SharedPreferences/settings hung, splash never finished even with auth timeout",
    "fix": "Unified bootstrap timeout forces proceed; settings load timeout; router created only after splash; web token store uses SharedPreferences",
    "tests": "flutter test widget_test passed; full suite run pending CI/local"
  }
}
