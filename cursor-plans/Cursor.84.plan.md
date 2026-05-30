{
  "metadata": {
    "title": "Cursor.84 — Android home-screen IP widget",
    "updatedAt": "2026-05-30"
  },
  "part84": {
    "tasks": [
      "Add home_widget ^0.9.2 to Flutter pubspec",
      "Create IpHomeWidgetService + shared widget data keys",
      "Android IpNoteHomeWidgetProvider with branded RemoteViews layout (fa/en strings)",
      "Sync widget on home IP load, background monitor, and app bootstrap from cached IP",
      "Register widget receiver in AndroidManifest"
    ]
  },
  "result84": {
    "status": "completed",
    "flutter": [
      "lib/core/widget/ip_home_widget_keys.dart",
      "lib/core/widget/ip_home_widget_service.dart",
      "home_controller.dart",
      "ip_change_background_runner.dart",
      "main.dart"
    ],
    "android": [
      "IpNoteHomeWidgetProvider.kt",
      "res/layout/widget_ip_note.xml",
      "res/xml/ip_note_home_widget_info.xml",
      "res/drawable/widget_background.xml",
      "res/values/widget_colors.xml",
      "res/values/widget_strings.xml",
      "res/values-fa/widget_strings.xml",
      "AndroidManifest.xml receiver"
    ],
    "usage": "Long-press Android home screen → Widgets → IPNote.ir → drag widget; IP updates when app loads IP or background monitor runs",
    "verify": "flutter pub get (pub.dev auth required in this environment) then flutter build apk --debug"
  }
}
