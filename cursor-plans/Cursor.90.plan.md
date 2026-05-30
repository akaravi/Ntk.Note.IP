{
  "metadata": {
    "title": "Cursor.90 — Flutter release API URL + login fix",
    "updatedAt": "2026-05-30"
  },
  "part90": {
    "tasks": [
      "Default release AppConfig to https://ipnote.ir without dart-define",
      "Login: useCookies=false for Bearer token response",
      "Sanitize Dio 500 error messages on login screen"
    ]
  },
  "result90": {
    "status": "completed",
    "rootCause": "Release APK built without --dart-define defaulted to http://10.0.2.2:5340; login also showed raw Dio 500 text",
    "verify": "Rebuild release APK; login should hit https://ipnote.ir"
  }
}
