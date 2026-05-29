# Flutter mobile — Stage S7 close checklist

Post-S9 mobile track (Parts 47–57). Use before store release.

## Core features

- [x] Home: My IP, lookup, map, QR, local IP, CLI commands
- [x] Auth: Bearer login, secure token storage, refresh on 401, dashboard guard
- [x] Dashboard: timeline, map, export CSV/JSON, server sync
- [x] IP notes CRUD + edit (authenticated)
- [x] Tools: IP compare
- [x] Theme (light/dark/system) + fa/en i18n
- [x] Deep links (Android/iOS) + wwwroot verification files
- [x] OpenAPI codegen + Retrofit `IpnoteClient`
- [x] Drift local history
- [x] Biometric app lock
- [x] Background IP monitor + local notification
- [x] Haptics + in-app review prompt (5th dashboard visit)

## Before Go-Live

- [ ] Replace `TEAMID` / release SHA256 in `wwwroot/.well-known/`
- [ ] Physical device App Links verification
- [ ] Release signing — see [store-release-checklist.md](store-release-checklist.md) (`key.properties`, `flutter-release-build.ps1`)
- [ ] Store metadata fa/en
- [x] FCM client wiring (register/unregister on auth) — replace Firebase config files for real push; see [fcm-setup.md](fcm-setup.md)

## Verify locally

```powershell
.\scripts\flutter-ci.ps1
cd src\Mobile\ntk_note_ip_app
flutter test
```

## Related

- [flutter-mobile.md](flutter-mobile.md)
- [ADR-018](../decisions/ADR-018-Flutter-Mobile-App.md)
- [deep-links.md](deep-links.md)
