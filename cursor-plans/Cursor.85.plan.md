{
  "metadata": {
    "title": "Cursor.85 — Android APK size + versioned artifact names",
    "updatedAt": "2026-05-30"
  },
  "part85": {
    "tasks": [
      "Enable R8 minify + shrinkResources + proguard-rules.pro",
      "Limit release ABIs to armeabi-v7a and arm64-v8a (drop x86)",
      "Flutter release flags: --split-per-abi, --obfuscate, --split-debug-info, --tree-shake-icons",
      "Publish Android artifacts with version suffix at end of filename",
      "Wire publish into flutter-release-build.ps1, _build-all-projects.ps1, flutter-release.yml CI"
    ]
  },
  "result85": {
    "status": "completed",
    "files": [
      "scripts/flutter-android-publish.ps1",
      "scripts/flutter-release-build.ps1",
      "src/Mobile/ntk_note_ip_app/android/app/build.gradle.kts",
      "src/Mobile/ntk_note_ip_app/android/app/proguard-rules.pro",
      "_build-all-projects.ps1",
      ".github/workflows/flutter-release.yml",
      "docs/mobile/store-release-checklist.md"
    ],
    "naming": "app-arm64-v8a-release_0.1.1-build2.apk (version from pubspec.yaml, + -> -build)",
    "publishDir": "publish/flutter/android",
    "verify": "flutter-release-build.ps1 -Target apk -SkipCi OK — arm64 ~22.4 MB, armeabi-v7a ~20.0 MB (split-per-ABI, no x86)"
  }
}
