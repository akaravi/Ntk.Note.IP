# IPNote.ir — Architecture Overview

## Product

**IPNote.ir** — IP intelligence, notes, and network tooling for web and mobile (Flutter).

## Current Solution Map (baseline audit — Stage 0)

| Project | Assembly | Role |
|---------|----------|------|
| `Domain` | `Ntk.Note.IP.Domain` | Entities (`IpNote`, `IpLookupRecord`, Todo sample), events |
| `Application` | `Ntk.Note.IP.Application` | CQRS, `ErrorExceptionResult`, validation |
| `Infrastructure` | `Ntk.Note.IP.Infrastructure` | EF Core SQLite, Identity |
| `Web` | `Ntk.Note.IP.Web` | Minimal API + Angular SPA |
| `Shared` | `Ntk.Note.IP.Shared` | Aspire service names, `IPNoteDb` |
| `ServiceDefaults` | `Ntk.Note.IP.ServiceDefaults` | Health, OpenTelemetry |
| `AppHost` | `Ntk.Note.IP.AppHost` | Aspire orchestration |

## API Surface (template baseline)

- `/api/Users` — Identity (register/login)
- `/api/TodoLists`, `/api/TodoItems` — sample CRUD
- `/api/WeatherForecasts` — sample read
- `/health`, `/alive` — liveness (Development)
- `/scalar` — OpenAPI UI

## Data Flow

```
Angular / Flutter → Web (Minimal API) → MediatR → Domain
                                      ↘ Infrastructure → SQLite
```

## Clients

| Client | Path | Stack |
|--------|------|-------|
| Web | `src/Web/ClientApp` | Angular 21, theme toggle |
| Flutter | `src/Mobile/ntk_note_ip_app` | Riverpod, Dio, go_router; CI: `flutter-mobile.yml` |

## DevOps (Stage S9 — core track)

CI/CD, GHCR, compose prod, smoke/uptime workflows, and runbooks under `docs/runbooks/` and `docs/devops/`.  
Close checklist: [s9-stage-close-checklist.md](../devops/s9-stage-close-checklist.md).  
Public status: `/status.html`.

See `plan.prompt/IPNote.plan.prompt.json` for full 10-stage roadmap (1000 subtasks).
