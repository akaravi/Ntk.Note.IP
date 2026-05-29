# Flutter mobile — runbook

## Prerequisites

- Flutter stable SDK (`flutter doctor`)
- Running IPNote API (default dev: `http://localhost:5340` via AppHost)
- Android emulator uses `http://10.0.2.2:5340` (configured in `AppConfig`)

## Project path

`src/Mobile/ntk_note_ip_app`

## Local CI (analyze + test)

```powershell
.\scripts\flutter-ci.ps1
```

## Full stack (API + health + URLs)

```powershell
.\scripts\run-all.ps1
```

See [local-dev-run-all.md](local-dev-run-all.md).

## Run on device / emulator

```powershell
cd src\Mobile\ntk_note_ip_app
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5340
```

Physical device on same LAN:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.x.x:5340
```

## Routes

| Path | Auth | Description |
|------|------|-------------|
| `/` | No | Home — My IP, details, history, CLI commands |
| `/tools` | No | Compare two IPs |
| `/login` | No | Bearer login |
| `/dashboard` | Yes | Timeline, map, export |
| `/ip-notes` | Yes | CRUD notes |

## API contract

- Envelope: `{ "isSuccess", "errorMessage", "data" }`
- Lists in `data` as JSON array (e.g. `GET /api/v1/IpLookup`)
- Identity login: `POST /api/v1/Users/login` → `accessToken` (not envelope)
- Refresh: `POST /api/v1/Users/refresh` with stored `refreshToken` (not envelope)

## Auth session

- Login/refresh use unauthenticated `IpnoteClient` (`ipnoteAuthClientProvider`).
- API calls use Bearer from `AuthController` + `AuthTokenRefreshInterceptor` (401 → refresh → retry once; failure → logout).

## Local IP history (Drift)

IP lookup history is stored in SQLite (`lib/core/history/database/app_database.dart`). On first launch after upgrade, entries import automatically from the legacy `SharedPreferences` key `ipnote.ip-history`.

Regenerate Drift after schema changes:

```powershell
cd src\Mobile\ntk_note_ip_app
dart run build_runner build
```

## In-app review (S7-100)

After the **5th** successful dashboard load, the app may show the platform store review dialog (when available).

## Release build

```powershell
.\scripts\flutter-release-build.ps1 -Target appbundle
```

See [store-release-checklist.md](../mobile/store-release-checklist.md).

## Stage S7 close

See [s7-stage-close-checklist.md](../mobile/s7-stage-close-checklist.md).

## Background IP monitor (S7-044)

Enable on **Dashboard** → «Background IP monitor». Registers a Workmanager task (~30 min, network required). On public IP change, app shows a local notification and appends Drift history.

- Android: `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, `INTERNET` in manifest.
- iOS: background fetch is system-scheduled; reliability varies.
- API base URL is persisted on launch from `API_BASE_URL` / `AppConfig`.

## Biometric app lock (S7-037)

After sign-in, open **Dashboard** and enable **Unlock with biometrics**. When the app returns from background, a lock screen prompts fingerprint / Face ID.

Requires a device with biometrics (not supported on all emulators).

## OpenAPI codegen (S7-006)

```powershell
.\scripts\flutter-openapi-gen.ps1
```

- Syncs `src/Web/wwwroot/openapi/v1.json` → `openapi/v1.json`
- Generates `lib/api/generated` (tags: IpLookup, IpNotes, Users) via `swagger_parser` + `build_runner`
- Domain mapping: `lib/api/openapi_mappers.dart` (repositories use generated DTO parsers)
- HTTP reads/writes: `IpnoteClient` (retrofit) via `ipnoteClientProvider` for IpLookup and IpNotes datasources

## CI

GitHub Actions: `.github/workflows/flutter-mobile.yml` on changes under `src/Mobile/**`.

## Related

- [ADR-018](../decisions/ADR-018-Flutter-Mobile-App.md)
- [Mobile README](../../src/Mobile/README.md)
