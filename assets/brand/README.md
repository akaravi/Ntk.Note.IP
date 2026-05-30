# IPNote.ir brand icon

Master asset: `app_icon.png` (1024×1024).

## Regenerate platform icons

```powershell
# From repo root
.\scripts\sync-brand-icons.ps1

cd src\Mobile\ntk_note_ip_app
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

Flutter: Android/iOS/Windows launcher + splash; **Flutter web** `web/icons` + `web/favicon.png`.  
Web: Angular `ClientApp`, React `ClientApp-React`, `wwwroot/favicon.png`.
