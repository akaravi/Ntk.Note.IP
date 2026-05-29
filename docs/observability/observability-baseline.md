# Observability baseline

## Health endpoints

| Path | Purpose | Tags |
|------|---------|------|
| `/health` | All checks | — |
| `/alive` | Liveness (`self`) | `live` |
| `/health/ready` | DB (+ Redis when configured) | `ready` |

Restrict these URLs at the reverse proxy in production; keep them enabled for orchestrators and uptime monitors.

Smoke scripts: `scripts/verify-health.ps1`, `scripts/post-deploy-smoke.ps1`.

## Metrics (Prometheus)

When `OpenTelemetry:EnablePrometheusEndpoint` is `true` (or env `OpenTelemetry__EnablePrometheusEndpoint=true`):

| Path | Content |
|------|---------|
| `/metrics` | Prometheus scrape (ASP.NET Core, HTTP client, runtime) |

Default is **off** in `appsettings.json` and `appsettings.Production.json`. Enable only on internal networks or behind auth at the proxy.

### Local stack with Prometheus + Grafana

```powershell
# Start Web with metrics (example env on host)
$env:OpenTelemetry__EnablePrometheusEndpoint = "true"
# docker compose prod + observability overlay (see docker-compose.observability.yml)
```

- Prometheus UI: http://localhost:9090  
- Grafana: http://localhost:3000 (default admin/admin — change in prod)

## Traces and logs (OpenTelemetry OTLP)

Set standard OTLP environment variables (no code change required):

| Variable | Example |
|----------|---------|
| `OTEL_EXPORTER_OTLP_ENDPOINT` | `http://otel-collector:4317` |
| `OTEL_SERVICE_NAME` | `ipnote-web` |

Aspire AppHost can inject OTLP in development. Production: point to Jaeger, Tempo, or a vendor collector.

Logging uses `OpenTelemetry` logging bridge when OTLP is configured (see `ServiceDefaults/Extensions.cs`).

## Suggested alerts (initial)

| Signal | Condition | Action |
|--------|-----------|--------|
| Readiness | `/health/ready` non-200 > 2 min | Page on-call |
| Liveness | `/alive` non-200 | Restart pod/container |
| Error rate | 5xx rate > 1% over 5 min | Investigate logs/traces |
| Latency | p95 HTTP > 2s | Scale or optimize hot paths |

## Uptime (external)

- CI: [uptime-monitoring.md](../runbooks/uptime-monitoring.md) — `uptime-monitor.yml` + `scripts/uptime-check.ps1`
- Manual: `scripts/staging-smoke.ps1` or external ping on `/health` and `/api/v1/IpLookup/GetMyIp`

## Related

- [database-backup.md](../runbooks/database-backup.md)
- [production-deploy.md](../runbooks/production-deploy.md)
- [ADR-002 Aspire](../decisions/ADR-002-Aspire-For-Orchestration-And-Testing.md)
