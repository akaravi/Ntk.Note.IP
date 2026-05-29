# Flutter store release checklist

Use after [S7 stage close](s7-stage-close-checklist.md) (Parts 47–58).

## 1. Version and API

- [ ] Bump `version` in `src/Mobile/ntk_note_ip_app/pubspec.yaml` (`major.minor.patch+build`)
- [ ] Set production API: `--dart-define=API_BASE_URL=https://api.ipnote.ir` (default in `scripts/flutter-release-build.ps1`)

## 2. Android signing

1. Create upload keystore (once):

```powershell
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Copy `android/key.properties.example` → `android/key.properties` (never commit).
3. Place `upload-keystore.jks` under `android/` and set `storeFile=../upload-keystore.jks` in `key.properties`.
4. `app/build.gradle.kts` uses release signing when `key.properties` exists.

## 3. Build artifacts

```powershell
.\scripts\flutter-ci.ps1
.\scripts\flutter-release-build.ps1 -Target appbundle
# optional: -Target apk | ipa (ipa needs macOS)
```

Outputs: `build/app/outputs/bundle/release/*.aab`

## 4. Deep links (Go-Live)

```powershell
# SHA-256 from release keystore:
keytool -list -v -keystore android\upload-keystore.jks -alias upload

.\scripts\update-deep-links.ps1 -AndroidReleaseSha256 <64-hex> -AppleTeamId <APPLE_TEAM_ID>
.\scripts\verify-deep-links-placeholders.ps1 -Strict
```

Deploy Web so `/.well-known/*` is live, then verify on a physical device (signed build).

## 5. Store consoles

| Platform | Track | Notes |
|----------|-------|--------|
| Google Play | Internal testing | Upload AAB; package `ir.ipnote.ntk_note_ip_app` |
| App Store | TestFlight | Archive on macOS; bundle `ir.ipnote.ntkNoteIpApp` |

- [ ] Store listing fa/en (screenshots, privacy policy URL)
- [ ] Data safety / privacy questionnaire
- [ ] Post-deploy: `.\scripts\post-deploy-smoke.ps1 -WebBaseUrl https://ipnote.ir -RequireTls -StrictDeepLinks`

## 6. CI release workflow

Workflow: [.github/workflows/flutter-release.yml](../../.github/workflows/flutter-release.yml)

- Manual: **Actions → Flutter Release Build → Run workflow**
- Tag: push `mobile-v1.0.0` to trigger build + artifact upload

### Secrets (optional, for signed AAB)

For signed AAB in GitHub Actions, store as secrets (do not commit):

- `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`

Generate `key.properties` in the workflow before `flutter build appbundle`.

## Related

- [flutter-mobile.md](../runbooks/flutter-mobile.md)
- [deep-links.md](../runbooks/deep-links.md)
- [production-deploy.md](../runbooks/production-deploy.md)
