# IPNote.ir — Mobile (Flutter)

## Project

`ntk_note_ip_app` — Android, iOS, Windows (dev).

**Home:** `GetMyIp` → `GetIpDetails`, OSM map preview, ISP/ASN/geo cards, QR, local Wi‑Fi IP, recent history, optional `ActionLookup` when signed in.

**Dashboard:** Timeline (local + server + notes), stats, search, country filter, aggregate map, CSV/JSON share.

**Notes:** `/ip-notes` — add/list/delete (auth required).

**Sync:** After login, server history merged locally; missing IPs uploaded via `ActionLookup`.

**Tools:** `/tools` — compare two IPs; home includes CLI curl snippets and 60s IP change watch.

## CI / local check

```powershell
.\scripts\flutter-ci.ps1
```

GitHub Actions: `.github/workflows/flutter-mobile.yml`

## Run (dev API on host)

```bash
cd src/Mobile/ntk_note_ip_app
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:5340
```

Android emulator uses `http://10.0.2.2:5340` by default in `AppConfig`.

Full runbook: [docs/runbooks/flutter-mobile.md](../../docs/runbooks/flutter-mobile.md)

## Architecture

- `lib/core` — config, Dio client, theme, device/local IP helpers
- `lib/domain` — entities, repositories, use cases
- `lib/data` — remote datasources, repository implementations
- `lib/presentation` — Riverpod, go_router, screens

See `docs/decisions/ADR-018-Flutter-Mobile-App.md`.
