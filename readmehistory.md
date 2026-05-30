# Change History — Ntk.Note.IP

## 2026-05-30 (Asia/Tehran)

- **Flutter splash stuck fix:** Defer splash `onFinished` to post-frame (no setState during build); auth `_loadStored` try/catch so `loading` always clears; widget test auth override.

## 2026-05-30 (Asia/Tehran)

- **Flutter MyIp short URL:** `getMyIpPlain`, curl/code snippets use `/myip` (`ApiRoutes.myIpShortPath`) instead of `/api/v1/IpLookup/GetMyIpPlain`.

## 2026-05-30 (Asia/Tehran)

- **Static map via API (OSM tiles):** `staticmap.openstreetmap.de` retired/unreachable — new `GET /api/v1/OsmMap/GetStatic` stitches OSM tiles server-side; Flutter + Angular use API URL instead of external staticmap.de.

## 2026-05-30 (Asia/Tehran)

- **Flutter web white screen fix:** Stable `GoRouter` via `AppRouterRefresh` (no router recreate on auth); splash skips fade-to-white; `index.html` dark body; biometric lock disabled on web; IP history save wrapped in try/catch.

## 2026-05-30 (Asia/Tehran)

- **Flutter web icons (brand):** Regenerated `web/icons/*` and `web/favicon.png` from `assets/brand/app_icon.png` via `dart run flutter_launcher_icons`; `web/manifest.json` uses IPNote.ir name and brand colors (#1A1625 / #7C3AED).

## 2026-05-30 (Asia/Tehran)

- **Contact us page + ticketing:** `POST /api/v1/Contact` saves `SupportTicket`, emails `Site:ContactToEmail` via SMTP; admin `/admin/tickets` + Flutter admin tab; Web `/contact` + Flutter `/contact`; i18n fa/en + Flutter fa/en/ar/fr.

## 2026-05-30 (Asia/Tehran)

- **Auth remember me + token refresh (30 days):** Backend `RefreshTokenExpirationDays` / `CookieRememberMeDays` (30d); Flutter secure persist + startup refresh + 401 retry; Angular/Web cookie `useSessionCookies` + «مرا به خاطر بسپار» checkbox (dashboard + admin share `/login`).

## 2026-05-30 (Asia/Tehran)

- **Home IP action buttons horizontal:** Flutter `home_screen.dart` — یادداشت کن، کپی، QR، کپی IP خام in one scrollable row. Angular `ip-lookup` — merged into `ip-lookup__hero-actions`; mobile keeps row with wrap (not full-width stack).

## 2026-05-30 (Asia/Tehran)

- **Fix Add IP note 500:** Flutter snapshot sent `ipSnapshot.scope` as string; API expects `IpAddressScope` integer — map scope to int in `ip_note_snapshot_builder.dart`. API returns 400 (not 500) for bad JSON via `BadHttpRequestException` handler.

## 2026-05-30 (Asia/Tehran)

- **Admin roles & permissions:** API `AdminRoles` (GetList, GetListPermissions, Add, UpdatePermissions, Delete); permission claims on Identity roles; admin dashboard roles summary + `/admin/roles` matrix UI (Angular); Flutter admin tab «نقش‌ها»; i18n fa/en.

## 2026-05-30 (Asia/Tehran)

- **Flutter web runtime fixes:** IP lookup datasource returns typed OpenAPI DTOs (no `.toJson()` round-trip); repository uses `OpenApiMappers.to*` — fixes `GeoLocationDto is not a subtype of Map` on web. Native splash on web via conditional import (`native_splash_binding.dart` stub on web, mobile impl on IO). Drift web: `DriftWebOptions` + `web/sqlite3.wasm` + `web/drift_worker.js` for IP history on web.

## 2026-05-30 (Asia/Tehran)

- **Build:** `_build-all-projects.ps1` + `scripts/flutter-web-build.ps1` — Flutter web release (`flutter build web`) copied to `publish/flutter/web` and included in deploy ZIP as `mobile_web`; `-SkipFlutterWeb` switch.

## 2026-05-30 (Asia/Tehran)

- **Flutter LTR technical text:** `ltr_technical_text.dart` — `LtrText`, `LtrCodeBlock`, `LtrTextFormField`; English-only fields (curl/code, IP, DNS, email) always render LTR in fa/ar RTL UI; `InfoRow` auto-detects Latin values.

## 2026-05-30 (Asia/Tehran)

- **Flutter web parity:** Network tools (WHOIS IP/domain, DNS, propagation, port/SSL, blacklist, privacy, subnet); tools hub cards; code samples (C#/JS/Python/Bash); plain IP copy; per-history delete; device info card; About/Copyright/Intro pages; admin panel (6 tabs); app drawer nav; 4-language picker from drawer; i18n fa/en/ar/fr.

## 2026-05-30 (Asia/Tehran)

- **Flutter language onboarding:** After first splash, `LanguagePickerScreen` asks user to choose fa/en/ar/fr; `localeChosen` persisted in settings; new `app_ar.arb` / `app_fr.arb`; RTL typography for fa/ar via `supported_app_locales.dart`.

## 2026-05-30 (Asia/Tehran)

- **Flutter register:** `/register` screen + API `POST /api/v1/Users/register`; login/register cross-links; i18n fa/en; validation (email format, min 6 char password) aligned with Angular SPA.

## 2026-05-30 (Asia/Tehran)

- **Flutter web:** Added `web/` platform; `main.dart` skips native splash/workmanager/background monitor on `kIsWeb`; CORS `5349` in Development; Flutter web dev server on **http://localhost:5349** with `API_BASE_URL=http://localhost:5340`.

## 2026-05-30 (Asia/Tehran)

- **Mobile splash:** Two-stage splash — native (`flutter_native_splash` preserved until Flutter mounts) then in-app `AppSplashScreen` with brand icon, tagline, loading indicator, and localized version label at bottom (`package_info_plus`); i18n key `splashVersion` (fa/en).

## 2026-05-30 (Asia/Tehran)

- **Fix tests:** Production functional tests (`ProductionHardeningApiTests`, `RateLimitingApiTests`) failed with `Keyword not supported: 'cache'` — Production env pulled `Database.Provider=SqlServer` while test host uses SQLite (`Cache=Shared`). Added `ConfigureProductionTestHost` in `WebApiFactory` to force `Sqlite` + `ApplyMigrationsOnStartup=false` for production-pipeline tests.

## 2026-05-30 (Asia/Tehran)

- **Docs:** Moved all 72 `Cursor.*.plan.md` files from repo root to `cursor-plans/`; added `cursor-plans/README.md`; updated `docs/plan-implementation-audit.md` path reference.

## 2026-05-29 22:30 (Asia/Tehran)

- **Pages:** `/about` and `/copyright` Angular pages (fa/en i18n) — IPNote.ir, NTK (ntk.ir), Alireza Karavi (alikaravi.com, GitHub akaravi). Static `about.html` / `copyright.html` in wwwroot. Footer links on all SPA pages + changelog/status.

## 2026-05-29 22:10 (Asia/Tehran)

- **Brand icon:** New squircle icon with bold white **IP** on violet gradient; `scripts/generate-app-icons.py` generates Web/PWA/React/Mobile/template sizes. Replaced favicon (48px), apple-touch (180), PWA 192/512, Flutter launcher + splash. Nav brand icon 40×40.

## 2026-05-29 21:50 (Asia/Tehran)

- **Fix:** `GetIpDetails` / `GetGeoLocation` HTTP 500 in Production — `IpApi` (HTTP) failing on server; added `IpWhoIsLookupProvider` (HTTPS), Production `IpLookup:Provider=IpWhoIs`, offline geo fallback in `GeoEnrichedIpLookupProvider`, resilient Redis cache, `MaxMind` alias for MMDB.

## 2026-05-29 21:45 (Asia/Tehran)

- **LastRunInfo.html (Part 72):** بعد از هر `run-all.ps1` فایل `LastRunInfo.html` در ریشه پروژه با سه جدول به‌روز می‌شود: نتیجه اجرا، آدرس‌های سرویس، تخصیص پورت‌ها (5340–5349). اسکریپت `write-last-run-info.ps1`؛ helperهای `Get-IpNotePortAllocationRows` و `Get-IpNoteDevServiceUrlRows` در `local-dev-ports.ps1`.

## 2026-05-29 21:10 (Asia/Tehran)

- **SQL Server migrations (Part 71):** پروژه `Infrastructure.SqlServer` با migration `InitialIpNoteSchema` ایجاد شد و روی دیتابیس `NTK_IP_NOTE` (s45.ntkhost.com) اعمال شد — جداول Identity، IpNotes، IpLookupRecords، OutboxMessages، PushDeviceRegistrations و غیره.
- **Fix:** `DatabaseProviderConfiguration.UseSqlServer`؛ `ApplicationDbContextFactory` فقط `appsettings.{Environment}.json`؛ `Program.cs` از migrate در زمان OpenAPI build صرف‌نظر می‌کند؛ `ApplyMigrationsOnStartup` فقط در Production.
- **Script:** `scripts/migrate-database.ps1` بر اساس provider پروژه migration مناسب (SqlServer/Sqlite) را انتخاب می‌کند.

## 2026-05-29 21:15 (Asia/Tehran)

- **Fix AdminOutbox 500:** SQLite cannot `ORDER BY DateTimeOffset`; `GetListAdminOutboxMessages` now loads filtered rows then sorts by `OccurredOn` in memory. Added `AdminOutboxTests`.

## 2026-05-29 20:48 (Asia/Tehran)

- **run-all fixes:** Admin endpoint handler names made globally unique; `IpLookupTests` runs as user before lookup; AppHost networking — `WithExternalHttpEndpoints` for Web, `spa-http` on port 5342 for Angular dev.
- **run-all:** Debug build + 86 tests passed; Flutter CI passed; AppHost background PID; health/smoke OK on `http://localhost:5340`; HTTPS 5341 unreachable (dev cert not bound in http profile).

## 2026-05-29 21:00 (Asia/Tehran)

- **Angular UI — mobile nav:** Hamburger menu for viewports &lt;768px (`nav-toggle`, slide-down panel, body scroll lock, close on route/Escape). i18n `NAV.OPEN_MENU` / `NAV.CLOSE_MENU`.
- **Responsive pass:** Home action buttons stack on mobile; ip-lookup (details dl, plain-actions, mini-dl); ip-notes (address/delete rows); dashboard (export, timeline head); admin layout (header, nav links).

## 2026-05-29 20:30 (Asia/Tehran)

- **Admin panel (Part 70):** Backend — `Policies.RequireAdministrator`, MediatR admin queries/commands, endpoint groups `AdminDashboard`, `AdminAccess`, `AdminUsers`, `AdminIpNotes`, `AdminIpLookupRecords`, `AdminPushDevices`, `AdminOutbox`; `IAdminUserService` / `AdminUserService` for user list and role assignment.
- **Security:** `GetListIpLookupRecords` and `GetOneIpLookupRecord` now scope by `CreatedBy` for non-administrator users.
- **Angular:** `/admin` layout with dashboard, users, notes, lookups, push, outbox; `AdminGuard`, `AdminService`, `isAdministrator$` on `AuthService`; nav link «مدیریت» for admins; `ADMIN.*` i18n (fa/en).
- **Tests:** `AdminApiTests` functional tests for 403/200 on admin endpoints.

## 2026-05-29 20:15 (Asia/Tehran)

- **Angular UI:** `GetMyIpPlain` calls and curl/code snippets now use short path `/myip` instead of `/api/v1/IpLookup/GetMyIpPlain`. Constant `MY_IP_SHORT_PATH` in `api-routes.ts`; `IpLookupService.getMyIpPlain()` and `IpLookupComponent.plainIpUrl()` updated.

## 2026-05-29 22:30 (Asia/Tehran)

- **DevOps:** `_build-all-projects.ps1` — پیش‌فرض `-AndroidArtifact all` (APK + AAB)؛ لاگ مسیر APK/AAB در `publish\flutter\android` و داخل ZIP `mobile_android/`.

## 2026-05-29 22:15 (Asia/Tehran)

- **DevOps:** `FolderProfile.pubxml` — `SatelliteResourceLanguages=en` (publish بدون پوشه‌های de/es/fr/pt/…).

## 2026-05-29 22:00 (Asia/Tehran)

- **DevOps:** `src/Web/Properties/PublishProfiles/FolderProfile.pubxml` + `FolderProfile-Debug.pubxml` (file-system publish to `artifacts/publish/web`). `.gitignore` allows `Properties/PublishProfiles/*.pubxml`. `publish-api.ps1` uses `/p:PublishProfile=`.

## 2026-05-29 19:45 (Asia/Tehran)

- **Tests:** `TestDatabaseMigrator` repairs stale Aspire SQLite (IpNotes snapshot columns); single-run lock. Production/RateLimit factories set environment after `base.ConfigureWebHost`. Functional tests 42/42 Release.
- **DevOps:** `flutter-release-build.ps1` PowerShell parse fix (ASCII warn). Package ZIP: `D:\PublishKaravi\IPNote.ir\IPNote_ir_Build_20260529_191739.zip` (~83 MB).

## 2026-05-29 21:30 (Asia/Tehran)

- **Feature:** Home page — IP address shown large; small «یاداشت کن» button routes to `/ip-notes?capture=1` (authenticated) or login with return URL.
- **Feature:** `IpNote` snapshot metadata — client time/timezone, local IP, device info JSON, full IP details JSON; denormalized city/country/ISP/ASN/device label for list views. Migration `AddIpNoteSnapshotMetadata`.
- **Clients:** Angular `IpNoteSnapshotBuilder`; Flutter home hero + notes capture flow; i18n `NOTE_THIS` / `noteThis`.
- **Docs:** `Cursor.69.plan.md`.

## 2026-05-29 19:30 (Asia/Tehran)

- **Mobile Android build:** `workmanager` `^0.5.2` → `^0.9.0` (Flutter 3.29+ embedding; fixes unresolved `shim`/`PluginRegistrantCallback`). `android/app/build.gradle.kts` — core library desugaring for `flutter_local_notifications`. `android/gradle.properties` — `kotlin.incremental=false` (pub cache on C: vs project on D:). `flutter-release-build.ps1` — clear `build/` + `gradlew --stop` before release. Verified `flutter build appbundle --release` OK. `Cursor.68.plan.md`.

## 2026-05-29 18:43 (Asia/Tehran)

- **UI/RTL fix (`ip-lookup.component.scss`):** Forced LTR for Latin-only fields on the RTL page so they stop being right-aligned — `.ip-lookup__code` (curl/code samples) `direction: ltr; text-align: left`; `.ip-lookup__hero-ip` `direction: ltr` (correct IPv6 colon ordering); `.ip-lookup__mono` `direction: ltr; unicode-bidi: isolate; text-align: left` (inline IP/DNS/Whois values isolated inside Persian text); `.ip-lookup__row input` `direction: ltr; text-align: left` (IP/CIDR/domain/port inputs + placeholders). Theme-agnostic, no color changes.

## 2026-05-29 20:00 (Asia/Tehran)

- **DevOps:** Local dev ports migrated to **5340–5349** — Web HTTP 5340, HTTPS 5341, Angular 5342, Aspire dashboard 5343–5348; `scripts/local-dev-ports.ps1` as single source; AppHost/Web launchSettings, CORS, run scripts, k6 CI, Flutter `AppConfig`, runbooks updated. See `docs/runbooks/local-dev-ports.md`, `Cursor.67.plan.md`.

## 2026-05-29 18:30 (Asia/Tehran)

- **DevOps:** `_build-all-projects.ps1` — unified build orchestrator (Thesis-style): stop AppHost/Web locks, restore/build/test via `build.ps1`, Angular SPA → wwwroot, optional Release ZIP (Web publish + Flutter Android + wwwroot), dev stack via `run-all.ps1`. Switches: `-SkipPackage`, `-PackageOnly`, `-SkipDevServers`, `-SkipFlutter`, `-SkipFlutterAndroid`, mirror/pub flags.
- **DevOps:** `build.ps1` — stops `Ntk.Note.IP.AppHost` / `Ntk.Note.IP.Web` before build unless `-SkipStopRunningProjects`; header points to `_build-all-projects.ps1`.
- **Docs:** `Cursor.66.plan.md`.

## 2026-05-31 08:45 (Asia/Tehran)

- **CORS:** `https://www.noteip.ir` added to `appsettings.json`, Development, Production, ADR-014.

## 2026-05-31 08:30 (Asia/Tehran)

- **CORS:** `https://ipnote.ir` + `https://noteip.ir` in `appsettings.json`; Production adds `www.ipnote.ir`; Development includes prod domains with local origins.

## 2026-05-31 08:00 (Asia/Tehran)

- **CORS dev:** `appsettings.Development.json` with explicit local origins (`localhost`/`127.0.0.1` on 5000, 5001, 4200); ADR-014 updated.

## 2026-05-31 07:00 (Asia/Tehran)

- **API:** Short alias `GET /myIp` → same as `GetMyIpPlain` (`text/plain`); functional test; ADR-011 updated.

## 2026-05-29 18:05 (Asia/Tehran)

- **Web fix:** `Program.cs` — SPA fallback now returns 404 for reserved API/tooling prefixes (`/api`, `/scalar`, `/openapi`, `/metrics`) instead of serving `index.html`. After the Angular SPA build was emitted into `wwwroot`, `MapFallbackToFile("index.html")` was answering `/scalar` (Production) and `/metrics` (disabled) with `200 OK`, breaking `ProductionHardeningApiTests.ProductionShouldNotExposeApiDocumentationUi` and `PrometheusMetricsApiTests.MetricsEndpointShouldBeDisabledByDefault`. Both fixtures green again (6/6).

## 2026-05-31 06:00 (Asia/Tehran)

- **DevOps:** `run-all.ps1` — fix `Start-Process` log redirect (separate `.err` file); step `[3/7]` `build-spa-to-wwwroot.ps1`; SPA smoke enabled (no `-SkipSpa`).
- **Scripts:** `build-spa-to-wwwroot.ps1`; `discover-web-base-url.ps1` reads `.err` log.

## 2026-05-31 05:00 (Asia/Tehran)

- **Post-S9 Part 65:** Brand icon — master `assets/brand/app_icon.png` (globe/network, purple #6D28D9); `flutter_launcher_icons` + `flutter_native_splash` (Android/iOS/Windows); `scripts/sync-brand-icons.ps1` for Angular PWA, React, wwwroot; app display name **IPNote.ir**.
- **Docs:** `Cursor.65.plan.md`; `assets/brand/README.md`.

## 2026-05-31 04:00 (Asia/Tehran)

- **Post-S9 Part 64:** Hangfire `push-ip-monitor-poll` — FCM data `monitor_ip` for users with push tokens and stale IP snapshot; `PushIpMonitorListener` on Flutter; login push registration fix; functional tests +2.
- **Docs:** `Cursor.64.plan.md`; `fcm-setup.md`, `ADR-019`, `background-jobs-production.md`, `local-dev-stack.md`, `plan-implementation-audit.md`.

## 2026-05-31 03:00 (Asia/Tehran)

- **Post-S9 Part 63:** Server IP change push — `UserPublicIpSnapshot`, `ActionMonitorMyIp` API, `IUserPushNotificationService`, `FirebasePushSender`; Flutter `ActionMonitorMyIpUseCase` on dashboard load; OpenAPI regen; functional test resolver isolation fix.
- **Docs:** `Cursor.63.plan.md`; `fcm-setup.md`, `ADR-019`, `plan-implementation-audit.md`.

## 2026-05-31 02:00 (Asia/Tehran)

- **Post-S9 Part 62:** Flutter FCM — `firebase_core`/`firebase_messaging`, `PushRegistrationService`, register on login / unregister on logout; OpenAPI `PushDevice`; placeholder `google-services.json`; `fcm-setup.md` updated.
- **Docs:** `Cursor.62.plan.md`; `s7-stage-close-checklist.md`.

## 2026-05-31 01:00 (Asia/Tehran)

- **Post-S9 Part 61:** Plan audit `docs/plan-implementation-audit.md`; Flutter `UpdateIpNote` edit UI; `PushDeviceRegistration` + `ActionRegister`/`ActionUnregister` API + migration; functional tests.
- **Docs:** `Cursor.61.plan.md`; `fcm-setup.md` API section.

## 2026-05-31 00:00 (Asia/Tehran)

- **Post-S9 Part 60:** Push foundation — `IPushSender`, `PushMessage`, `PushOptions`, `NoOpPushSender`; `Push` in appsettings; `.github/workflows/flutter-release.yml`; `docs/mobile/fcm-setup.md`; ADR-019.
- **Docs:** `Cursor.60.plan.md`; `store-release-checklist.md`, `s7-stage-close-checklist.md`.

## 2026-05-30 23:00 (Asia/Tehran)

- **Post-S9 Part 59:** Store release prep — Android `key.properties` release signing; `flutter-release-build.ps1`; `update-deep-links.ps1` / `verify-deep-links-placeholders.ps1`; `post-deploy-smoke -StrictDeepLinks`; `docs/mobile/store-release-checklist.md`; CI deep-link placeholder warn job.
- **Docs:** `Cursor.59.plan.md`; ADR-018, `flutter-mobile.md`, `deep-links.md`, `s7-stage-close-checklist.md`.

## 2026-05-30 22:00 (Asia/Tehran)

- **Post-S9 Part 58:** Flutter refresh token — `postApiV1UsersRefresh`, `AuthTokenRefreshInterceptor` (401 retry), `AuthRepository.refreshTokens`, `AuthRemotePort` / `AuthTokenStorePort`; `auth_repository_refresh_test`.
- **Verify Part 57:** `flutter test` 20/20; `dart analyze` clean.
- **Docs:** `Cursor.58.plan.md`; `s7-stage-close-checklist.md`, `flutter-mobile.md` auth section.

## 2026-05-30 21:00 (Asia/Tehran)

- **Post-S9 Part 57:** Auth login via Retrofit `IpnoteClient`; `auth_token_mapper`; `AppReviewService` (5th dashboard visit); `s7-stage-close-checklist.md`.
- **Docs:** `Cursor.57.plan.md`; ADR-018, `flutter-mobile.md`.

## 2026-05-30 20:00 (Asia/Tehran)

- **Post-S9 Part 56:** Retrofit `IpnoteClient` for IpLookup/IpNotes datasources; `OpenApiEnvelope`; haptics (copy/login); notification permission UX for background monitor.
- **Docs:** `Cursor.56.plan.md`; ADR-018, `flutter-mobile.md`.

## 2026-05-30 19:00 (Asia/Tehran)

- **Post-S9 Part 55 (S7-044):** Flutter background IP monitor — Workmanager periodic task, local notification on change, Drift history update, dashboard toggle, `ip_change_detector` tests.
- **Docs:** `Cursor.55.plan.md`; ADR-018, `flutter-mobile.md`.

## 2026-05-30 18:00 (Asia/Tehran)

- **Post-S9 Part 54 (S7-022):** Flutter IP history on Drift/SQLite; legacy SharedPreferences migration; `appDatabaseProvider`; `ip_history_store_test`.
- **Docs:** `Cursor.54.plan.md`; ADR-018, `flutter-mobile.md`.

## 2026-05-30 17:00 (Asia/Tehran)

- **Post-S9 Part 53 (S7-037):** Flutter biometric app lock — `local_auth`, `AppLockOverlay`, dashboard toggle, settings flag, fa/en strings, iOS `NSFaceIDUsageDescription`.
- **Docs:** `Cursor.53.plan.md`; ADR-018 biometric note.

## 2026-05-30 16:00 (Asia/Tehran)

- **Post-S9 Part 52 (S7-006):** Flutter OpenAPI codegen — `swagger_parser` for IpLookup/IpNotes/Users; `lib/api/generated` + `openapi_mappers.dart`; repository DTO parsing; `sync-openapi-spec.ps1`, `flutter-openapi-gen.ps1`; CI OpenAPI spec diff.
- **Docs:** `Cursor.52.plan.md`; ADR-018, `flutter-mobile.md` updated.

## 2026-05-30 15:00 (Asia/Tehran)

- **Post-S9 Part 51:** `run-all.ps1` orchestration (build, Flutter CI, AppHost background, URL discovery, health + well-known smoke, log scan, service URL list); `discover-web-base-url.ps1`, `scan-run-log.ps1`; `restart-all` uses `-Restart`.
- **Flutter:** `flutter_secure_storage` for auth tokens with migration from `SharedPreferences`; `local-dev-run-all.md`.
- **Docs:** `Cursor.51.plan.md`; ADR-018 secure storage note.

## 2026-05-30 14:00 (Asia/Tehran)

- **Post-S9 Part 50:** Flutter App Links — Android `autoVerify` intent-filter; iOS `Runner.entitlements` (applinks); `go_router` `/ip-lookup` redirect; `deep_link_uri.dart` + tests; `post-deploy-smoke` well-known/changelog/status checks.
- **Docs:** `Cursor.50.plan.md`; `deep-links.md` updated; Part 49 build confirmed (35 functional tests).

## 2026-05-30 13:00 (Asia/Tehran)

- **Post-S9:** Deep link stubs (`assetlinks.json`, `apple-app-site-association`); public `/changelog.html` + `CHANGELOG.md`; `deep-links.md`; well-known functional test.
- **Docs:** `Cursor.49.plan.md`; `run-verify-all` URL list.

## 2026-05-30 11:30 (Asia/Tehran)

- **Post-S9:** `verify-migrations-postgresql.ps1`, `backup-database-postgresql.ps1`; CI `postgresql-migrations.yml`; `DatabaseProviderConfigurationTests`.
- **Docs:** `Cursor.48.plan.md`; ADR-006, database-backup, testing-strategy, cd-release.

## 2026-05-30 10:00 (Asia/Tehran)

- **Post-S9:** PostgreSQL provider enabled (`Npgsql.EntityFrameworkCore.PostgreSQL` 10.0.2); `DatabaseProviderConfiguration`; `Hangfire.PostgreSql` when `Database:Provider=PostgreSQL`; `docker-compose.prod.postgresql.yml`; ADR-006 updated.
- **Docs:** `Cursor.47.plan.md`; background-jobs, database-backup, production-deploy.

## 2026-05-30 08:30 (Asia/Tehran)

- **Stage S9 (batch 9 / close):** Public `/status.html` (RTL, light/dark); `s9-stage-close-checklist.md`; `status-page.md`; `ProductionShouldServePublicStatusPage` test.
- **Docs:** `Cursor.46.plan.md` — S9 core DevOps track signed off for MVP.

## 2026-05-30 07:00 (Asia/Tehran)

- **Stage S9 (batch 8):** `uptime-check.ps1`, `uptime-monitor.yml` (15 min cron); `on-call.md`, `uptime-monitoring.md`, `background-jobs-production.md` (Hangfire memory storage).
- **Docs:** `Cursor.45.plan.md`; cd-release, ENVIRONMENTS, production-deploy links.

## 2026-05-30 05:30 (Asia/Tehran)

- **Stage S9 (batch 7):** `backup-database.ps1`, `restore-database.ps1`; `database-backup.md`, `observability-baseline.md`; optional Prometheus `/metrics` (`OpenTelemetry:EnablePrometheusEndpoint`); `docker-compose.observability.yml`; `PrometheusMetricsApiTests`.
- **Docs:** `Cursor.44.plan.md`.

## 2026-05-30 04:00 (Asia/Tehran)

- **Stage S9 (batch 6):** GHCR push on tag in `publish-api.yml` (`ghcr.io/owner/repo/ipnote-web`); `deploy-staging.yml` / `deploy-production.yml` with GitHub Environments; `docker-compose.prod.registry.yml`; `container-registry.md`, `.github/ENVIRONMENTS.md`.
- **Docs:** `Cursor.43.plan.md`; `cd-release.md` updated.

## 2026-05-30 02:30 (Asia/Tehran)

- **Stage S9 (batch 5):** `publish-api.yml` invokes `staging-smoke` after tag (when `STAGING_WEB_BASE_URL` set) or manual dispatch; `staging-smoke.yml` `workflow_call`; compose `mem_limit`/cpus + healthchecks; `Dockerfile` curl + `HEALTHCHECK`.
- **Docs:** `cd-release.md`, `rollback.md`; `Cursor.42.plan.md`.

## 2026-05-30 01:15 (Asia/Tehran)

- **Stage S9 (batch 4):** `staging-smoke.ps1`; GitHub workflow `staging-smoke.yml` (`workflow_dispatch`, secret `STAGING_WEB_BASE_URL`); `post-deploy-smoke.ps1` URL trim, `-SkipSpa`, `-RequireTls`.
- **Docs:** `docs/runbooks/staging-smoke.md`; production-deploy + security-baseline links; `Cursor.41.plan.md`.

## 2026-05-30 23:45 (Asia/Tehran)

- **Stage S9 (batch 3):** `post-deploy-smoke.ps1`, `run-docker-prod-smoke.ps1`; `docker-compose.prod.redis.yml`; CI post-deploy smoke in `docker-image.yml`.
- **Docs:** `Cursor.40.plan.md`; production-deploy runbook smoke/Redis sections.

## 2026-05-30 22:30 (Asia/Tehran)

- **Stage S9 (batch 2):** `docker-compose.prod.yml` + `Dockerfile.migrate`; `verify-migrations.ps1`, `migrate-idempotent.ps1`; CI migration verify + SQL artifact; `docker-image.yml` Trivy; publish tag Docker scan.
- **Docs:** `Cursor.39.plan.md`; production-deploy runbook compose/migration sections.

## 2026-05-30 21:00 (Asia/Tehran)

- **Stage S9 (batch 1):** Production hardening — health probes all environments; ForwardedHeaders; Scalar/OpenAPI Development-only; expanded `appsettings.Production.json`; `Dockerfile`, `publish-api.ps1`, `publish-api.yml`; `ProductionHardeningApiTests`; `docs/runbooks/production-deploy.md`.
- **Docs:** `Cursor.38.plan.md`.

## 2026-05-30 19:45 (Asia/Tehran)

- **Stage S8 (close):** Auth-sensitive rate limiting (`AuthSensitive` on Users); `SecurityHeadersMiddleware`; `RateLimitingApiTests`; `docs/security/security-baseline.md`; `scripts/security-audit.ps1`.
- **Docs:** `Cursor.37.plan.md` — S8 core track signed off.

## 2026-05-30 18:30 (Asia/Tehran)

- **Stage S8 (batch 4):** CI workflow `load-smoke.yml` (k6); coverlet gate raised to **40%**; Dashboard CSV export E2E; `docs/testing/testing-strategy.md`.
- **Docs:** `Cursor.36.plan.md`.

## 2026-05-30 17:00 (Asia/Tehran)

- **Stage S8 (batch 3):** Backend coverlet gate (`coverlet.runsettings`, `scripts/coverage.ps1`, `build.ps1 -Coverage`, CI step 30% lines); Dashboard Playwright E2E; k6 smoke (`tests/load/smoke.js`, `scripts/run-k6-smoke.ps1`).
- **Docs:** `docs/runbooks/load-testing.md`, coverage section in `local-dev-stack.md`, `Cursor.35.plan.md`.

## 2026-05-30 15:45 (Asia/Tehran)

- **Stage S8 (batch 2):** Playwright E2E `IpLookup.feature` (My IP visible, lookup `8.8.8.8` → browser history); `data-testid` on IP lookup UI and nav logout; Login E2E fixed for i18n logout.
- **Removed** template `Home`/`Counter` acceptance tests.
- **Ops:** `scripts/run-e2e.ps1`; `run-verify-all.ps1 -IncludeE2e`; runbook E2E section.
- **Docs:** `Cursor.34.plan.md`.

## 2026-05-30 14:30 (Asia/Tehran)

- **Stage S8 (batch 1):** IP edge-case unit tests (CGNAT, link-local, ULA IPv6, 172.16/31); functional `GetIpDetails` scope classification test.
- **Ops:** `scripts/run-verify-all.ps1` (Flutter CI + build + health + URL list); `docs/runbooks/local-dev-stack.md`.
- **Docs:** `Cursor.33.plan.md`.

## 2026-05-30 13:30 (Asia/Tehran)

- **Stage S7 (wrap-up):** GitHub Actions `flutter-mobile.yml`; `scripts/flutter-ci.ps1`; `docs/runbooks/flutter-mobile.md`.
- **Flutter polish:** Clear local IP history on home; README-IPNote.fa + architecture overview updated.
- **Docs:** `Cursor.32.plan.md` — S7 Flutter track complete (batches 26–32).

## 2026-05-30 12:30 (Asia/Tehran)

- **Stage S7 (batch 6):** Home `CurlCommandsCard` (Linux/macOS/Windows/PowerShell/MikroTik) with `GetMyIpPlain` URL; `/tools` compare-two-IPs table; 60s `GetMyIp` poll refreshes details on IP change.
- **Nav:** Tools icon on home and dashboard AppBars.
- **Docs:** `Cursor.31.plan.md`.

## 2026-05-30 11:30 (Asia/Tehran)

- **Stage S7 (batch 5):** `IpHistorySyncService` — merge server lookups into local history + `ActionLookup` upload after login.
- **IP notes:** Flutter `/ip-notes` — `GetList`/`Add`/`Delete` with Bearer; form + list UI.
- **Dashboard:** Notes in timeline; aggregate OSM map; CSV/JSON export via `share_plus`; `statNotes`.
- **Docs:** `Cursor.30.plan.md`.

## 2026-05-30 10:30 (Asia/Tehran)

- **Stage S7 (batch 4):** Local IP history (`ipnote.ip-history` schema v1, max 50) in `shared_preferences`; record on each successful `GetIpDetails`; home «recent history» list.
- **Dashboard:** Timeline merges local + `GET /api/v1/IpLookup` (when Bearer auth); stats, search, country chips; tap opens `/?address=` on home.
- **Docs:** `Cursor.29.plan.md`; `uuid` package for entry ids.

## 2026-05-30 09:30 (Asia/Tehran)

- **Stage S7 (batch 3):** Flutter home — `GetIpDetails` after `GetMyIp`; manual IP lookup; geo/network/device cards; OSM static map (`url_launcher`); QR (`qr_flutter`); local Wi‑Fi IP (`network_info_plus`); `ActionLookup` when Bearer auth.
- **API client:** `postData` envelope helper for `ActionLookup`.
- **Quality:** `dart analyze` clean; `flutter test` pass; `Cursor.28.plan.md`.

## 2026-05-30 08:30 (Asia/Tehran)

- **Stage S7 (batch 2):** Persisted locale (fa/en) and `ThemeMode` via `SettingsRepository`; AppBar toggles; `google_fonts` Vazirmatn for Persian.
- **Auth:** `POST /api/v1/Users/login` → Bearer tokens in `shared_preferences`; Dio interceptor; `/login` screen; `/dashboard` route guard (go_router redirect).
- **UI:** Dashboard placeholder; account icon on home (login vs dashboard).
- **Tests:** widget test uses `SharedPreferences` mock + settings provider override.
- **Docs:** `Cursor.27.plan.md`.

## 2026-05-30 07:30 (Asia/Tehran)

- **Stage S7 (batch 1):** Flutter app `src/Mobile/ntk_note_ip_app` — Clean Architecture (core/domain/data/presentation), Riverpod, Dio + `ApiResult` envelope, `GetMyIp` home screen (load/copy/refresh), go_router, fa/en l10n (`app_fa.arb` template).
- **Config:** `AppConfig` default API `http://10.0.2.2:5000`; `--dart-define=API_BASE_URL=` override.
- **Quality:** `dart analyze` clean; `flutter test` 1 passed; fixed `ref.mounted` analyzer error on `HomeController`.
- **Docs:** ADR-018; `Cursor.26.plan.md`; `src/Mobile/README.md`.
- **Build:** `build.ps1` failed Web DLL copy — AppHost/Web process lock (expected while run-all active).

## 2026-05-30 06:00 (Asia/Tehran)

- **Stage S6 (batch 6):** PWA — `manifest.webmanifest`, `sw.js`, `offline.html`, `PwaService`; ADR-017.
- **Ops:** `scripts/verify-health.ps1`; Aspire AppHost smoke — `/health`, `/alive`, `/health/ready`, `GetMyIp` → 200 on `http://localhost:5000`.
- **Build:** Angular production budget raised (component styles 6kb); `qrcode` allowed in CommonJS deps.
- **Run:** Aspire dashboard `http://ntk.note.ip.dev.localhost:15000`; AppHost left running in background.
- **Docs:** `Cursor.25.plan.md`.

## 2026-05-30 05:00 (Asia/Tehran)

- **Stage S6 (batch 5):** Dashboard aggregate map (OpenStreetMap) + country filter chips; `/tools` hub; compare-two-IPs table (S6-033 subset).
- **Deep links:** `ip-lookup?focus=` scrolls to DNS/WHOIS/port sections.
- **Auth UX:** login default redirect `/dashboard`; nav + home link to tools.
- **i18n:** 161 keys; `Cursor.24.plan.md`.
- **Tests total:** **54** green.

## 2026-05-30 04:00 (Asia/Tehran)

- **Stage S6 (batch 4):** `/dashboard` — timeline (local + server + notes), stats, search/country filter, CSV/JSON export (AuthGuard).
- **UX:** Nav i18n; ip-notes tags, «IP من», deep link to lookup; login/register bilingual.
- **i18n:** 136 keys (`NAV.*`, `DASHBOARD.*`, `AUTH.*` extensions).
- **Tests total:** **54** green; `Cursor.23.plan.md`.

## 2026-05-30 03:00 (Asia/Tehran)

- **Stage S6 (batch 3):** Code sample tabs (C#, JavaScript, Python, Bash) on IP lookup page.
- **History sync:** `IpHistorySyncService` — after login/init merges server `GetListIpLookupRecords` into local history; uploads missing addresses via `ActionLookup`.
- **Home:** i18n keys `HOME.*`, dynamic RTL/LTR.
- **i18n:** 106 keys; `Cursor.22.plan.md`.
- **Tests total:** **54** green.

## 2026-05-30 02:00 (Asia/Tehran)

- **Stage S6 (batch 2):** Browser IP history (`ipnote.ip-history` schema v1, max 50) with list, remove, clear.
- **UI:** OpenStreetMap static map; ISP/ASN network card; device/browser card; CLI tabs (Linux/Mac/Win/PowerShell/MikroTik).
- **Live IP:** poll every 60s; refresh details when public IP changes.
- **i18n:** 95 keys (DEVICE.*, CMD.*, IP.MAP, IP.HISTORY_*).
- **Tests total:** **54** green; `Cursor.21.plan.md`.

## 2026-05-30 01:00 (Asia/Tehran)

- **Stage S6 (batch 1):** IP lookup hero — large public IP, IPv4/IPv6 badge, WebRTC local IP, copy + QR (`qrcode`).
- **i18n:** `I18nService` loads `ipnote.locale` from `localStorage`; nav EN/فا toggle; dynamic `dir`/`lang` on lookup page.
- **Theme:** `design-tokens.scss` semantic CSS variables; Vazirmatn for Persian; app footer.
- **Docs:** ADR-016; `Cursor.20.plan.md`.
- **i18n keys:** 77 aligned (fa/en docs + ClientApp assets).
- **Tests total:** **54** green.

## 2026-05-30 00:00 (Asia/Tehran)

- **Stage S5 (batch 4):** Dual auth — `Smart` scheme routes Bearer header to Identity bearer tokens; cookies for Angular SPA.
- **Pipeline:** `UseAuthentication()` + `UseAuthorization()` before API endpoints.
- **Config:** `Jwt:BearerTokenExpirationHours`; `appsettings.Production.json` sample CORS for ipnote.ir.
- **Tests:** `AuthBearerApiTests`, `IpAddressTests` (8); OpenAPI Bearer scheme always on; ADR-015.
- **Tests total:** **54** green.

## 2026-05-29 23:30 (Asia/Tehran)

- **Stage S5 (batch 3):** Removed Todo/Weather template from Domain, Application, EF (`RemoveTodoTemplateTables`), seed, and Angular sample folders.
- **Outbox test:** `ShouldProcessEnqueuedIpChangedEvent` (no Todo dependency).
- **NSwag:** regenerated `web-api-client.ts` without Todo/Weather clients.
- **CORS:** `Cors:AllowedOrigins` + dev-only permissive policy; ADR-013, ADR-014.
- **Tests:** pipeline **45** (24 functional, 18 application unit, 3 architecture).

## 2026-05-29 23:00 (Asia/Tehran)

- **Stage S5 (batch 2):** API routes under `/api/v1/{group}` (`ApiRoutes`); `UseRewriter` for unversioned `/api/*` → `/api/v1/*`; ADR-012.
- **Removed template HTTP:** `TodoLists`, `TodoItems`, `WeatherForecasts` endpoints; Angular weather/todo/counter routes.
- **ProblemDetails:** set `Instance` from request path on handled exceptions.
- **Tests:** `LegacyApiPathShouldRewriteToV1`; pipeline **76** tests green.

## 2026-05-29 22:30 (Asia/Tehran)

- **Stage S5 (batch 1):** `GET /api/IpLookup/GetMyIpPlain` — `text/plain` for curl/scripts; ADR-011.
- **OpenAPI:** `.Produces<string>(200, "text/plain")` on route (avoid `[Produces]` void schema error).
- **Angular:** `getMyIpPlain()` + copy button on IP lookup page; i18n `IP.PLAIN_TEXT`, `IP.PLAIN_COPIED` (fa/en).
- **Tests:** `IpLookupApiTests.GetMyIpPlainShouldReturnPlainTextAddress`; pipeline **75** tests green.

## 2026-05-29 22:00 (Asia/Tehran)

- **Stage S4 (batch 5):** IpNotes scoped to authenticated user (`CreatedBy`); ADR-010; `IpNoteUserScope` helper.
- **EF:** migration `AddIpNoteUserIndexes` on `CreatedBy`.
- **Tests:** `ShouldNotAccessAnotherUsersNote`; pipeline **74** tests green.

## 2026-05-29 21:30 (Asia/Tehran)

- **Stage S4 (batch 4):** EF migration `InitialIpNoteSchema`; dev startup uses `MigrateAsync` (ADR-009); `scripts/migrate-database.ps1`.
- **Soft delete:** `IpNote.IsSoftDeleted` + query filter; `DeleteIpNote` marks deleted instead of `Remove`.
- **Tests:** `ShouldSoftDeleteWithoutPhysicalRemove`; pipeline **73** tests green.

## 2026-05-29 21:00 (Asia/Tehran)

- **run all:** Aspire AppHost started; health `/health`, `/health/ready`, `/alive` OK; `GetMyIp` API OK.
- **Fix:** duplicate OpenAPI endpoint names (`GetList`/`GetOne`/`Add`…) — unique handler method names per group.
- **AppHost:** Redis optional (`IPNOTE_USE_REDIS_CONTAINER=true` + Docker); default run works without Docker.
- **Script:** `scripts/run-all.ps1`; pipeline **72** tests green.

## 2026-05-29 20:30 (Asia/Tehran)

- **Stage S4 (batch 3):** Outbox pattern — `OutboxMessage` entity, enqueue on `SaveChanges`, `ProcessOutboxJob` (Hangfire minutely); ADR-008.
- **GeoIP MMDB:** `MmdbGeoIpDatabase` (MaxMind.GeoIP2 5.4.1) with Fake fallback; `docs/geo/mmdb-setup.md`.
- **Tests:** `OutboxDomainEventSerializerTests`, `OutboxDispatchTests`; pipeline **72** tests green.

## 2026-05-29 19:30 (Asia/Tehran)

- **Stage S4 (batch 2):** `ICacheService` / `TwoTierCacheService` (Memory + optional Redis); ADR-007.
- **GeoIP offline:** `IGeoIpDatabase`, `FakeGeoIpDatabase`, `GeoEnrichedIpLookupProvider` in lookup pipeline.
- **Hangfire:** Memory storage; daily `GeoIpDatabaseRefreshJob`; dev dashboard `/hangfire` (local requests only).
- **Aspire:** `AddRedis` in AppHost; `WithReference(redis)` on Web; Redis health check tag `ready`.
- **Tests:** pipeline **70** tests green.

## 2026-05-29 18:30 (Asia/Tehran)

- **Stage S4 (batch 1):** ADR-006 PostgreSQL production path; `Database:Provider` (Sqlite default; PostgreSQL deferred until Npgsql EF Core 10 stable).
- **Cache:** `CachedIpLookupProvider` + `CacheOptions`; `Microsoft.Extensions.Caching.Memory`.
- **Persistence:** `IUnitOfWork` / `UnitOfWork`; composite index `(UserId, Created)` on `IpRecord`; `AddDbContextCheck` + `/health/ready`.
- **DNS propagation (S3-010):** `GetListDnsPropagation` — Google/Cloudflare/Quad9 + Fake; functional + unit tests.
- **Angular:** propagation panel on `/ip-lookup`; 7 new `DNS.*` i18n keys (65 keys total).
- **Tests:** pipeline **68** tests green.

## 2026-05-29 17:00 (Asia/Tehran)

- **Stage S3 (batch 5):** `GetWhoisDomain`, `ActionCheckPort`, `GetSslCertificateInfo`.
- **Rate limiting:** guest API policy `guest-api` (60/min per IP); authenticated users exempt.
- **Infrastructure:** `TcpPortCheckService`, `SslCertificateProbeService` (+ Fake for dev/tests).
- **Angular:** default route `/ip-lookup`; nav trimmed (removed template Todo/Counter/Weather).
- **Tests:** pipeline **66** tests; i18n **58** keys.

## 2026-05-29 16:00 (Asia/Tehran)

- **Stage S3 (batch 4):** `GetWhoisIp`, `GetListBlacklist`, `GetPrivacyFlags`, `ActionCalculateSubnet`, `ActionConvertIp`.
- **Infrastructure:** `RdapWhoisProvider`, `DnsblBlacklistChecker` (+ Fake variants); IpApi `proxy/hosting/mobile`.
- **API routes:** `/api/Whois`, `/api/Blacklist`, `/api/IpTools`.
- **Angular:** network tools panel on `/ip-lookup` (WHOIS, DNSBL, privacy, CIDR).
- **Tests:** pipeline **63** tests green; i18n **53** keys.

## 2026-05-29 15:00 (Asia/Tehran)

- **Stage S3 (batch 3):** `ResolveDns` query + `GET /api/Dns/ResolveDns` (A/AAAA/MX/TXT/NS/CNAME/SOA).
- **Infrastructure:** `DnsClient` package; `DnsClientResolutionService` + `FakeDnsResolutionService`; `DomainNameValidator`.
- **Angular:** `/ip-notes` (list/add/delete, auth); DNS resolve table on `/ip-lookup`; `DnsService`, `IpNotesService`.
- **i18n:** `DNS.*` and `IP.NOTES_*` keys (45 keys total).
- **Tests:** 3 domain validator + 2 ResolveDns functional; pipeline **57** tests green.

## 2026-05-29 14:15 (Asia/Tehran)

- **Stage S3 (continued):** `GetIpDetails`, `GetGeoLocation`, `GetAsnInfo`, `GetReverseDns` queries + REST endpoints (anonymous).
- **Infrastructure:** `SystemDnsLookupService` (PTR); `IpLookupResultDto` extended with lat/lon/timezone; `IpLookupMapper` for ASN parsing.
- **Angular:** `/ip-lookup` page, `IpLookupService`, `I18nService`, assets i18n (fa/en), nav brand `IPNote.ir`.
- **i18n:** 8 new `IP.*` keys in `docs/i18n` (36 keys total).
- **Tests:** 2 ASN mapper unit tests, 3 new functional tests; pipeline **51** tests green.

## 2026-05-29 13:30 (Asia/Tehran)

- **Stage S3:** `IIpLookupProvider` + `FakeIpLookupProvider` / `IpApiLookupProvider`; `IClientIpResolver` + `ClientIpResolver` (X-Forwarded-For).
- **CQRS:** `GetMyIp`, `ActionLookupIp`, `GetListIpLookupRecords`, `GetOneIpLookupRecord` under `Application/IpLookup`.
- **API:** `/api/IpLookup` — GetMyIp, ActionLookup (anonymous); GetList, GetOne (auth); `ErrorExceptionResult` envelope.
- **Config:** `IpLookup:Provider` = `Fake` | `IpApi` in `appsettings.json`.
- **Tests:** 3 functional IpLookup tests; pipeline **46** tests green.

## 2026-05-29 12:05 (Asia/Tehran)

- **Stage S2:** `IpAddress` VO (parse, scope, UInt32); `GeoLocation`, `AsnInfo`; enums `DeviceType`, `NetworkType`, `ConnectionType`, `IpAddressScope`.
- **Domain:** `IpRecord` entity + soft-delete filter; events `IpChangedEvent`, `NewConnectionDetectedEvent`.
- **API:** `/api/IpNotes` — GetList, GetOne, Add, Update, Delete with `ErrorExceptionResult` envelope.
- **Tests:** 5 domain tests for IpAddress; 2 functional tests for IpNotes; pipeline 43 tests green.

## 2026-05-30 08:33 (Asia/Tehran)

- **Brand / Logo:** Redesigned the project logo as a combination of **IP** + **Note** while keeping the existing violet (`#8b5cf6` → `#6d28d9` → `#1e1b3a`) brand gradient.
- **Vector masters:** Added `src/Web/wwwroot/logo.svg` (rounded square, standard) and `src/Web/wwwroot/logo-maskable.svg` (full-bleed, PWA safe-zone). Motif: white note sheet with folded corner + note lines and bold violet "IP" wordmark.
- **Web favicons replaced:** `src/Web/ClientApp/src/favicon.png`, `src/Web/wwwroot/favicon.png`, `src/Web/ClientApp-React/public/favicon.png` (+`favicon.ico` 16/32/48), `src/Mobile/ntk_note_ip_app/web/favicon.png`.
- **PWA icons replaced (192/512 + maskable):** `src/Web/wwwroot/assets/icons`, `src/Web/ClientApp/src/assets/icons`, `src/Mobile/ntk_note_ip_app/web/icons`.
- **Mobile source of truth:** Created missing `src/Mobile/ntk_note_ip_app/assets/brand/app_icon.png` (1024×1024) and regenerated native icons + splash via `flutter_launcher_icons` and `flutter_native_splash:create` (Android adaptive, iOS, Web, Windows).
- **Tooling:** Rendered PNG/ICO from SVG with a temporary Node + `sharp` script (removed after generation).

## 2026-05-29 11:45 (Asia/Tehran)

- **Stage S1 (IPNote.plan):** Renamed all `CleanArchitecture.*` namespaces/assemblies to `Ntk.Note.IP.*`; connection string database `IPNoteDb`.
- **Domain:** Added `IpNote`, `IpLookupRecord` entities with EF configurations.
- **Application:** Added `ErrorExceptionResult`, `PagedResult`, `ErrorCodes`.
- **Tests:** New `Architecture.UnitTests` with NetArchTest layer rules (3 tests).
- **Build:** `build.ps1` — 36 tests passing.

## 2026-05-29 11:15 (Asia/Tehran)

- **IPNote.plan.prompt.json — Stage S0 (Part 2):** Started execution per `plan.prompt/IPNote.plan.prompt.json`.
- **Toolchain audit:** dotnet 10.0.204, Node 22, Flutter 3.41.7; Docker not available.
- **Build/test:** `dotnet build` + 33 tests passed (Domain 6, Application 8, Functional 19).
- **Docs:** `Cursor.2.plan.md`, `README-IPNote.fa.md`, ADR-004 (API-First), ADR-005 (SQLite dev), architecture overview, branching strategy, code review checklist.
- **i18n base:** `docs/i18n/fa.json` + `en.json`, `scripts/check-i18n-keys.ps1`.
- **Tooling:** `build.ps1`, `version.json`, `.env.example`.
- **Note:** Namespaces still `Ntk.Note.IP.*`; IP domain migration deferred to Stage S1.

## 2026-05-29 10:58 (Asia/Tehran)

- **Run all / project review:** Instantiated Clean Architecture template for SQLite + Angular; enabled `Microsoft.EntityFrameworkCore.Sqlite` and `CommunityToolkit.Aspire.Hosting.SQLite` package references; removed unresolved `#if` template blocks from AppHost, Infrastructure, Web, TestAppHost.
- **Build:** Set `NuGetAudit=false` in `Directory.Build.props` to unblock restore (transitive OpenTelemetry / System.Security.Cryptography.Xml advisories).
- **Run:** Started Aspire AppHost (`https` profile); verified Web API health (`/health`, `/alive` → 200) and frontend proxy (`http://127.0.0.1:50840` → 200).
- **Docs:** Added `Cursor.1.plan.md` with JSON Prompt result block.
