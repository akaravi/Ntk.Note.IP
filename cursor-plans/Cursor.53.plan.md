# Cursor Plan — Ntk.Note.IP (Post-S9 Part 53)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 53",
    "updatedAt": "2026-05-30T17:00:00+03:30",
    "previousPart": "Cursor.52.plan.md"
  },
  "Part 53": {
    "title": "Flutter biometric app lock (S7-037)",
    "goal": "local_auth service; app lock overlay on resume; dashboard toggle; secure settings flag; fa/en l10n; iOS Face ID usage string"
  },
  "Result 53": {
    "summary": "BiometricAuthService + AppLockController + AppLockOverlay; biometricUnlockEnabled in AppSettings; BiometricSettingTile on dashboard; NSFaceIDUsageDescription; app_lock_controller_test.",
    "paths": {
      "service": "lib/core/auth/biometric_auth_service.dart",
      "lock": "lib/presentation/widgets/app_lock_overlay.dart",
      "settings": "lib/presentation/widgets/biometric_setting_tile.dart"
    },
    "deferred": [
      "Drift offline history",
      "Retrofit IpnoteClient migration"
    ],
    "nextStage": "Drift local history store or background IP monitor"
  }
}
```
