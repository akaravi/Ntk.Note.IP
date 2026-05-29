# ADR-018: Flutter mobile client

## Status

Accepted (2026-05-30)

## Context

IPNote.ir needs native Android/iOS clients consuming the same `/api/v1` backend as the Angular SPA.

## Decision

- Flutter app at `src/Mobile/ntk_note_ip_app`.
- Clean Architecture folders: `core`, `domain`, `data`, `presentation`.
- State: Riverpod; HTTP: Dio with `ApiResult` envelope matching backend `isSuccess` / `data`.
- Navigation: go_router; l10n: `app_fa.arb` (template) + `app_en.arb`.
- Theme: Material 3 with violet seed aligned to web Pico theme.

## Consequences

- OpenAPI codegen (S7-006): `swagger_parser` + committed `lib/api/generated`; `openapi_mappers.dart` maps DTOs to domain entities; regen via `scripts/flutter-openapi-gen.ps1`.
- Batch 2: Bearer login (`/api/v1/Users/login`), token store, theme/locale prefs, dashboard route guard (placeholder UI).
- Batch 3: `GetIpDetails`, OSM static map, ISP/geo/device cards, QR, local Wi‑Fi IP, `ActionLookup` when authenticated.
- Batch 4: Local history store (web-aligned JSON in `shared_preferences`), dashboard timeline (local + server list), deep link `/?address=`.
- Batch 5: History sync on auth, IP notes screen, dashboard aggregate map + CSV/JSON share export.
- Batch 6: CLI curl tabs on home, `/tools` IP compare, 60s live IP poll.
- Ping/traceroute (no backend API), Drift migration, and `UpdateIpNote` remain optional follow-ups.
- Auth tokens: `flutter_secure_storage` (Android encrypted shared prefs); one-time migration from legacy `SharedPreferences` keys.
- Biometric app lock (S7-037): `local_auth` + `AppLockOverlay` on resume when `biometricUnlockEnabled`; toggle on dashboard.
- Local IP history (S7-022): Drift/SQLite (`AppDatabase`); one-time migration from legacy `SharedPreferences` JSON.
- Background IP monitor (S7-044): `workmanager` periodic `GetMyIp`; local notification + Drift entry on change; toggle on dashboard.
- Retrofit datasources: `IpnoteClient` for IpLookup/IpNotes/Auth login; `OpenApiEnvelope` maps generated DTO envelopes to `ApiResult`.
- In-app review (S7-100): `AppReviewService` after 5th dashboard visit.
- Auth refresh: `POST /api/v1/Users/refresh` + `AuthTokenRefreshInterceptor` on 401.
- CI: `.github/workflows/flutter-mobile.yml`; local `scripts/flutter-ci.ps1`; runbook `docs/runbooks/flutter-mobile.md`.
- Store release: `scripts/flutter-release-build.ps1`, `android/key.properties` signing, `docs/mobile/store-release-checklist.md`, CI `flutter-release.yml`.
- Remote push: `PushRegistrationService` + FCM (Part 62); replace Firebase config for real delivery; server send still [ADR-019](ADR-019-Push-Notifications.md).
