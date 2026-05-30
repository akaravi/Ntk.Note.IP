# Cursor Plan — Ntk.Note.IP (Flutter web restart fix)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 73",
    "updatedAt": "2026-05-30T08:00:00+03:30",
    "previousPart": "Cursor.72.plan.md"
  },
  "Part 73": {
    "title": "Fix Flutter web restart on Chrome :5349",
    "goal": "Resolve runtime errors after flutter run -d chrome --web-port=5349",
    "errors": [
      "PlatformException: flutter_native_splash removeSplashFromWeb on web",
      "TypeError: GeoLocationDto is not a subtype of Map<String, dynamic>"
    ],
    "actions": [
      "Conditional native splash binding (stub on web, mobile on dart.library.io)",
      "IpLookupRemoteDataSource returns typed DTOs; repository maps with OpenApiMappers.to*",
      "dart analyze + flutter test",
      "Restart flutter web on http://localhost:5349"
    ],
    "files": [
      "src/Mobile/ntk_note_ip_app/lib/core/splash/native_splash_binding*.dart",
      "src/Mobile/ntk_note_ip_app/lib/data/datasources/ip_lookup_remote_datasource.dart",
      "src/Mobile/ntk_note_ip_app/lib/data/repositories/ip_lookup_repository_impl.dart",
      "src/Mobile/ntk_note_ip_app/lib/main.dart",
      "src/Mobile/ntk_note_ip_app/lib/presentation/screens/splash/app_splash_screen.dart"
    ]
  },
  "Result 73": {
    "summary": "Splash plugin excluded on web via conditional import. IP lookup uses direct DTO mapping. analyze clean, 23/23 tests pass. Flutter web restarted on :5349.",
    "devUrl": "http://localhost:5349",
    "apiUrl": "http://localhost:5340"
  }
}
```
