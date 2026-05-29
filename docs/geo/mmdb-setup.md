# GeoLite2 MMDB setup (offline GeoIP)

1. Create a MaxMind account and download **GeoLite2 City** (`GeoLite2-City.mmdb`).
2. Place the file at `src/Web/data/GeoLite2-City.mmdb` (or set `GeoIp:MmdbPath`).
3. Set `GeoIp:Provider` to `Mmdb` in `appsettings.json` or environment.
4. Restart the Web API. Logs should show `GeoIP MMDB loaded`.

Without the file, `MmdbGeoIpDatabase` falls back to `FakeGeoIpDatabase`.
