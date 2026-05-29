# Background jobs (Hangfire) in production

## Current behaviour

| Component | Setting |
|-----------|---------|
| Storage | `MemoryStorage` (Sqlite dev) or **PostgreSQL** (`hangfire` schema) when `Database:Provider=PostgreSQL` |
| Server | `AddHangfireServer()` — runs in **all** environments |
| Dashboard | `/hangfire` — **Development only** (`Program.cs`) |

Registered recurring jobs: see `HangfireJobRegistration.cs`:

- `geoip-mmdb-refresh` — daily
- `outbox-dispatch` — every minute
- `push-ip-monitor-poll` — default every 15 minutes (FCM data `monitor_ip` when `Push:Enabled` and snapshot stale)

## Production implications

- **Restart = queued/running job state lost** — acceptable for MVP; not for strict SLAs on scheduled IP watches.
- **No multi-instance coordination** — do not scale Web to multiple replicas with memory storage (duplicate job runs).
- **Dashboard disabled in Production** — use logs, Hangfire API, or future persistent storage UI.

## PostgreSQL storage (production)

When `Database:Provider=PostgreSQL`, jobs persist in schema `hangfire` on the same database as the app. Run migrations before first Hangfire use (included in `dotnet ef database update`).

For multiple Web replicas, configure Hangfire distributed locks (future) or run a single job runner instance.

## SQLite / dev

Memory storage — jobs do not survive restart. Dashboard at `/hangfire` (Development only).

## Verify jobs after deploy

1. Check application logs for Hangfire server start.
2. Trigger a known recurring job window (or run manual job in Development).
3. Confirm side effects (e.g. outbox processing) in DB.

## Related

- [production-deploy.md](production-deploy.md)
- [on-call.md](on-call.md)
- [ADR-008 Outbox](../decisions/ADR-008-Outbox-Domain-Events.md)
