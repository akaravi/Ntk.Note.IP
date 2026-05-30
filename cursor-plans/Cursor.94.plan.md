{
  "metadata": {
    "title": "Cursor.94 — No external CDN project law enforcement",
    "updatedAt": "2026-05-30T23:35:00+03:30"
  },
  "Part 1": {
    "law": "No runtime loading from third-party CDNs",
    "actions": [
      ".cursor/rules/no-external-cdn.mdc (alwaysApply)",
      "scripts/verify-no-external-cdn.ps1 + CI hooks in build scripts",
      "Angular/React: @fontsource self-hosted fonts, removed fonts.googleapis.com",
      "Flutter web: --no-web-resources-cdn mandatory",
      "Flutter mobile: removed google_fonts; bundled Vazirmatn in assets/fonts"
    ]
  },
  "Result 1": {
    "verify": ".\\scripts\\verify-no-external-cdn.ps1 -IncludePublishOutput",
    "rebuild": [
      ".\\scripts\\build-spa-to-wwwroot.ps1",
      ".\\scripts\\flutter-web-build.ps1 -SkipCi"
    ]
  }
}
