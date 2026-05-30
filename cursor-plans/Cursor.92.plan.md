{
  "metadata": {
    "title": "Cursor.92 — Android APK filename includes app name",
    "updatedAt": "2026-05-30T23:05:00+03:30"
  },
  "Part 1": {
    "request": "Include app display name in Android APK/AAB publish filenames",
    "actions": [
      "Get-FlutterAppNameSlug from version.json product (IP Note -> IP-Note)",
      "Get-VersionedAndroidArtifactBaseName replaces Gradle app- prefix",
      "Publish-FlutterAndroidArtifacts uses slug + version suffix",
      "CI flutter-release.yml mirrors APP_SLUG logic",
      "docs/mobile/store-release-checklist.md examples updated"
    ]
  },
  "Result 1": {
    "naming": "IP-Note-arm64-v8a-release_0.1.2-build3.apk",
    "source": "version.json product + pubspec version",
    "files": [
      "scripts/flutter-android-publish.ps1",
      ".github/workflows/flutter-release.yml",
      "docs/mobile/store-release-checklist.md",
      "readmehistory.md"
    ]
  }
}
