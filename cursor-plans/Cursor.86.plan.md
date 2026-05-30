{
  "metadata": {
    "title": "Cursor.86 — Android widget auto-fetch IP",
    "updatedAt": "2026-05-30"
  },
  "part86": {
    "tasks": [
      "Native WidgetIpFetcher: GET /api/v1/IpLookup/GetMyIp on widget update",
      "Show IP immediately without opening app; loading state while fetching",
      "Persist to HomeWidget SharedPreferences; 30 min periodic refresh",
      "Flutter bootstrap saves widget_api_base_url; updated fa/en widget strings"
    ]
  },
  "result86": {
    "status": "completed",
    "files": [
      "WidgetIpFetcher.kt",
      "IpNoteHomeWidgetProvider.kt",
      "widget_strings.xml (values + values-fa)",
      "ip_note_home_widget_info.xml",
      "ip_home_widget_service.dart",
      "ip_home_widget_keys.dart",
      "main.dart"
    ],
    "behavior": "Widget fetches public IP on add/update; tap only opens app (optional)"
  }
}
