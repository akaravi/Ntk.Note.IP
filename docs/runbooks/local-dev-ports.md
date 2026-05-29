# Local dev ports (5340–5349)

Canonical map for **local** execution. Production/Docker use other ports (e.g. 8080).

| Port | Service |
|------|---------|
| **5340** | Web API HTTP |
| **5341** | Web API HTTPS |
| **5342** | Angular `ng serve` (Aspire `PORT`) |
| **5343** | Aspire dashboard HTTP |
| **5344** | Aspire dashboard HTTPS |
| **5345** | Dashboard OTLP HTTP |
| **5346** | Dashboard resource service HTTP |
| **5347** | Dashboard OTLP HTTPS |
| **5348** | Dashboard resource service HTTPS |
| **5349** | Reserved |

## Configured in

- `src/Web/Properties/launchSettings.json`
- `src/AppHost/Properties/launchSettings.json`
- `src/AppHost/Program.cs` (Aspire endpoint pins)
- `src/Web/appsettings.Development.json` (CORS)
- `scripts/local-dev-ports.ps1` (scripts helper; also feeds **LastRunInfo.html** port table)
- Flutter `AppConfig` default: `http://10.0.2.2:5340`

After `run-all.ps1`, see **`LastRunInfo.html`** at repo root for execution results, service URLs, and this port map.

## Quick URLs

- API: http://localhost:5340
- Scalar: http://localhost:5340/scalar
- Dashboard: http://ntk.note.ip.dev.localhost:5343
- SPA (Aspire): http://localhost:5342

## Related

- [local-dev-stack.md](local-dev-stack.md)
- [local-dev-run-all.md](local-dev-run-all.md)
