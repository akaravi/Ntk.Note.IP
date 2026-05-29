# Deep links and App Links

## Web routes (Universal Links / App Links)

| URL | Web (Angular) | Flutter app |
|-----|---------------|-------------|
| `https://ipnote.ir/ip-lookup?address=8.8.8.8` | IP lookup + query | `/?address=8.8.8.8` (map in app) |
| `https://ipnote.ir/dashboard` | Dashboard (auth) | `/dashboard` |
| `https://ipnote.ir/ip-notes` | Notes (auth) | `/ip-notes` |

Validate query parameters server-side; do not pass untrusted deep link data to shell commands.

## Verification files (hosted by Web)

| File | Purpose |
|------|---------|
| `/.well-known/assetlinks.json` | Android App Links |
| `/.well-known/apple-app-site-association` | iOS Universal Links |

Source: `src/Web/wwwroot/.well-known/`

### Before production

```powershell
.\scripts\update-deep-links.ps1 -AndroidReleaseSha256 <sha256> -AppleTeamId <APPLE_TEAM_ID>
.\scripts\verify-deep-links-placeholders.ps1 -Strict
```

1. **Android:** Release keystore SHA-256 (`keytool -list -v -keystore android/upload-keystore.jks`).
2. **iOS:** Apple Team ID + bundle `ir.ipnote.ntkNoteIpApp` in `apple-app-site-association`.
3. Serve `apple-app-site-association` with `Content-Type: application/json` (default static file is OK on ASP.NET).
4. Verify: [Google Digital Asset Links](https://developers.google.com/digital-asset-links/tools/generator), Apple CDN cache (can take hours).

## Flutter / native (Part 50)

| Platform | Config |
|----------|--------|
| Android | `android/app/src/main/AndroidManifest.xml` — `VIEW` intent-filter, `android:autoVerify="true"`, hosts `ipnote.ir` / `www.ipnote.ir` |
| iOS | `ios/Runner/Runner.entitlements` — `applinks:ipnote.ir`, `applinks:www.ipnote.ir` |
| Flutter | `go_router` route `/ip-lookup` redirects to `/?address=`; `lib/core/navigation/deep_link_uri.dart` + unit tests |

Package: `ir.ipnote.ntk_note_ip_app` (Android) · bundle `ir.ipnote.ntkNoteIpApp` (iOS).

## Related

- [ADR-018 Flutter](../decisions/ADR-018-Flutter-Mobile-App.md)
- [production-deploy.md](production-deploy.md)
