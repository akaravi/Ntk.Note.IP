# ADR-019: Push notifications (FCM/APNs)

## Status

Accepted (foundation + server send path, 2026-05-31) — production Firebase credentials still manual

## Context

Users want alerts when their public IP changes even if the app is not running. Local notifications via Workmanager (S7-044) cover periodic checks but not server-initiated events or reliable delivery on all OEMs.

## Decision

1. Introduce `IPushSender` in Application with `PushMessage` (device token, title, body, optional data map).
2. Default implementation: `NoOpPushSender` when `Push:Provider` is `NoOp` (production-safe default).
3. Optional `FirebasePushSender` when `Push:Provider` is `Firebase` and a service account path is configured.
4. Mobile: local background monitor + FCM token registration (`ActionRegister`); dashboard triggers `ActionMonitorMyIp` when authenticated.
5. Server: `UserPublicIpSnapshot` per user; on IP change, `UserPushNotificationService` calls `IPushSender` for all active device tokens.
6. CI: `flutter-release.yml` builds release AAB/APK; optional signing via GitHub secrets documented in store checklist.

## Consequences

- `PushDeviceRegistration` stores tokens (Part 61); `UserPublicIpSnapshot` stores last seen public IP (Part 63).
- IP change push: client `ActionMonitorMyIp` + Hangfire `push-ip-monitor-poll` (FCM wake) when snapshot stale
- Flutter must not depend on real `google-services.json` in CI (placeholder allowed); real FCM delivery requires Firebase project on client and server credentials on API host.

## Related

- [fcm-setup.md](../mobile/fcm-setup.md)
- [ADR-018](ADR-018-Flutter-Mobile-App.md)
