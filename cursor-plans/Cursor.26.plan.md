# Cursor Plan — Ntk.Note.IP (Stage S7 batch 1)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 26",
    "updatedAt": "2026-05-30T07:30:00+03:30",
    "previousPart": "Cursor.25.plan.md"
  },
  "Part 26": {
    "title": "Stage S7 — Flutter scaffold, Clean Architecture, GetMyIp home",
    "goal": "S7-001..015 subset: flutter create, core/domain/data/presentation, Riverpod, Dio ApiResult, fa/en l10n, Material 3 theme, home screen"
  },
  "Result 26": {
    "summary": "Flutter app at src/Mobile/ntk_note_ip_app with Clean Architecture; GET /api/v1/IpLookup/GetMyIp on home; ADR-018; dart analyze clean; widget test pass.",
    "flutter": {
      "path": "src/Mobile/ntk_note_ip_app",
      "org": "ir.ipnote",
      "packages": ["flutter_riverpod", "dio", "go_router", "shared_preferences"],
      "layers": ["core/config+network+theme", "domain", "data", "presentation"],
      "apiDefault": "http://10.0.2.2:5000 (Android emulator); override --dart-define=API_BASE_URL=",
      "endpoint": "GET /api/v1/IpLookup/GetMyIp",
      "l10n": ["app_fa.arb (template)", "app_en.arb", "flutter gen-l10n"],
      "theme": "Material 3 seed #6D28D9 (violet, aligned with web)"
    },
    "quality": {
      "dartAnalyze": "no issues",
      "flutterTest": "1 passed (IpNoteApp home title)",
      "buildPs1": "skipped Web copy — Ntk.Note.IP.Web PID 46900 file lock (AppHost still running)"
    },
    "docs": ["docs/decisions/ADR-018-Flutter-Mobile-App.md", "src/Mobile/README.md"],
    "deferred": [
      "S7-006 OpenAPI codegen",
      "S7 auth Bearer + secure storage",
      "S7 theme/locale persistence (shared_preferences wired, not used)",
      "S7 dashboard, local history (Drift/Hive)",
      "CI flutter job",
      "Windows Developer Mode symlinks for plugin builds"
    ],
    "nextStage": "S7 batch 2: locale/theme prefs, login Bearer, lookup detail screen"
  }
}
```
