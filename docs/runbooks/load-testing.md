# Load testing (k6)

Smoke load on health and `GetMyIp` (read-only, no auth).

## Prerequisites

Install [k6](https://k6.io/docs/get-started/installation/) (e.g. `winget install k6` on Windows).

## Run

With the Web API running (e.g. AppHost on port 5340):

```powershell
.\scripts\run-k6-smoke.ps1
# custom base URL:
.\scripts\run-k6-smoke.ps1 -BaseUrl http://localhost:5340
```

Script: `tests/load/smoke.js` — 5 VUs for 30s, thresholds on error rate and p95 latency.

## CI

Workflow `.github/workflows/load-smoke.yml` builds the Web API, waits for `/health`, then runs `tests/load/smoke.js` with k6 on `ubuntu-latest`.
