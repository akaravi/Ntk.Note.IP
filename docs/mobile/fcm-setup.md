# FCM push setup

Mobile already supports **local notifications** when the background IP monitor detects a change (Workmanager). **Remote push (FCM/APNs)** registers the device token with the API after login when Firebase is configured.

## Backend (Part 60–63)

- `IPushSender` + `PushMessage` in Application layer
- `NoOpPushSender` by default (`Push:Provider` = `NoOp`, `Push:Enabled` = false in `appsettings.json`)
- `FirebasePushSender` when `Push:Provider` = `Firebase` and `Push:FirebaseCredentialsPath` points to a service account JSON (FCM HTTP v1)
- `POST /api/v1/IpLookup/ActionMonitorMyIp` (auth): compares client IP to `UserPublicIpSnapshot`; on change sends push to registered devices via `IUserPushNotificationService`

## API (Part 61)

| Method | Route | Purpose |
|--------|-------|---------|
| POST | `/api/v1/PushDevice/ActionRegister` | Store FCM token (`deviceToken`, `platform`: android/ios) |
| POST | `/api/v1/PushDevice/ActionUnregister` | Remove token on logout |

Flutter client: call after `firebase_messaging` yields a token (not wired until `google-services.json` exists).

Homogeneous lists and `ErrorExceptionResult` envelope apply to any future list endpoints.

## Flutter (Part 62)

Packages: `firebase_core`, `firebase_messaging`.

1. Create Firebase project.
2. Replace placeholder `android/app/google-services.json` with the file from Firebase Console (package `ca.karavi.ipnote.app`).
3. Add `ios/Runner/GoogleService-Info.plist` from Firebase (iOS).
4. On login / app resume with session, app calls `ActionRegister` via `PushRegistrationService`.
5. On logout, `ActionUnregister` with last stored token.
6. When signed in, dashboard load calls `ActionMonitorMyIp` so the server can detect IP changes and send remote push (requires server `Push:Provider=Firebase` for delivery).
7. Hangfire job `push-ip-monitor-poll` (every 15 min by default) sends FCM data `{ "type": "monitor_ip" }` when the user's snapshot is older than `Push:IpMonitorPollIntervalMinutes`; the app reports IP via `ActionMonitorMyIp`.

Placeholder `google-services.json` allows CI/build; **real FCM delivery requires your Firebase project**.

Until Firebase is configured, use **Dashboard → Background IP monitor** for on-device polling notifications.

## Related

- [store-release-checklist.md](store-release-checklist.md)
- [ADR-019](../decisions/ADR-019-Push-Notifications.md)
- [flutter-release.yml](../../.github/workflows/flutter-release.yml) — unsigned/signed AAB CI
