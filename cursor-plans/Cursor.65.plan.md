# Cursor Plan — Ntk.Note.IP (Post-S9 Part 65)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 65",
    "updatedAt": "2026-05-31T05:00:00+03:30",
    "previousPart": "Cursor.64.plan.md"
  },
  "Part 65": {
    "title": "Brand app icon across all clients",
    "goal": "Design IPNote.ir icon (purple globe/network); apply to Flutter Android/iOS/Windows, Angular PWA, React, wwwroot; no default launcher/favicon"
  },
  "Result 65": {
    "summary": "Master assets/brand/app_icon.png; flutter_launcher_icons + flutter_native_splash; sync-brand-icons.ps1 for web; display names IPNote.ir; PWA manifest 192/512.",
    "paths": {
      "master": "assets/brand/app_icon.png",
      "script": "scripts/sync-brand-icons.ps1",
      "flutter": "src/Mobile/ntk_note_ip_app/assets/brand/"
    },
    "verification": {
      "androidMipmaps": "ic_launcher + adaptive + splash drawables",
      "iosAppIcon": "21 PNG sizes",
      "windowsIco": "runner/resources/app_icon.ico",
      "angular": "favicon.png, apple-touch-icon.png, assets/icons/*"
    }
  }
}
```
