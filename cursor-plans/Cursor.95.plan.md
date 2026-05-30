{
  "metadata": {
    "title": "Cursor.95 — Clients config (panel-web, flutter-app)",
    "updatedAt": "2026-05-30T21:00:00+03:30"
  },
  "Part 1": {
    "request": "Clients section with Secret and AllowedOrigins for Flutter and dashboard",
    "implementation": [
      "Clients:panel-web / Clients:flutter-app in appsettings",
      "IRegisteredClientStore + CORS merge from all client origins",
      "ClientHmacValidationMiddleware (optional when headers + real secret)",
      "ADR-015 + docs/runbooks/registered-clients.md"
    ]
  },
  "Result 1": {
    "clientIds": ["panel-web", "flutter-app"],
    "productionOrigins": {
      "panel-web": ["https://ipnote.ir", "https://panel.ipnote.ir", "..."],
      "flutter-app": ["https://app.ipnote.ir", "https://app.noteip.ir"]
    }
  }
}
