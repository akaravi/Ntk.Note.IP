# Testing strategy (IPNote.ir)

## Pyramid

| Layer | Projects / tools | Purpose |
|-------|------------------|---------|
| Architecture | `Architecture.UnitTests` | Layering and dependency rules |
| Domain unit | `Domain.UnitTests` | Value objects, enums (IP scopes, etc.) |
| Application unit | `Application.UnitTests` | Handlers, serializers, validators |
| API functional | `Application.FunctionalTests` | MediatR + SQLite in-memory |
| Web E2E | `Web.AcceptanceTests` (Playwright + Aspire) | SPA critical paths |
| Mobile | `scripts/flutter-ci.ps1` | analyze + widget smoke |
| Load smoke | `tests/load/smoke.js` (k6) | `/health`, `GetMyIp` under light load |

## Local commands

```powershell
.\build.ps1                    # unit + functional + i18n keys
.\build.ps1 -Coverage          # + coverlet gate (40% lines)
.\scripts\run-e2e.ps1          # Playwright (Aspire stack)
.\scripts\run-k6-smoke.ps1     # k6 (API must be running)
.\scripts\run-verify-all.ps1 -Coverage -IncludeE2e
```

## CI

- `build.yml` — build, coverage gate (40%), Playwright E2E
- `load-smoke.yml` — k6 against standalone Web API
- `flutter-mobile.yml` — Flutter analyze/test

## Coverage

- Settings: `coverlet.runsettings`
- Gate script: `scripts/coverage.ps1` (combined line % on `Ntk.Note.IP.*` assemblies)
- Reports under `artifacts/coverage/` (gitignored)

## E2E paths covered

- IP lookup: My IP, manual lookup → browser history
- Auth: login valid / invalid
- Dashboard: stats, CSV export header

## Stage 8 DoD (subset implemented)

- [x] Backend coverage measurement and CI gate (40%)
- [x] Playwright critical web paths (6 scenarios)
- [x] IP edge-case unit/functional tests
- [x] k6 smoke on high-traffic read endpoints (+ CI workflow)
- [x] Flutter CI workflow
- [x] Rate limiting tests (guest + auth)
- [x] Security headers middleware
- [x] `scripts/security-audit.ps1` (NuGet + npm audit)
- [x] PostgreSQL migration verify in CI (`postgresql-migrations.yml` + service container)
- [ ] Testcontainers integration suite (optional; service container covers migrate path)
- [ ] OpenAPI contract tests
- [ ] DAST (OWASP ZAP)
- [ ] 50%+ line coverage target

See [security baseline](../security/security-baseline.md).
