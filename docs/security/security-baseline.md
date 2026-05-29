# Security baseline (IPNote.ir)

## Implemented controls

| Area | Implementation |
|------|----------------|
| Guest API rate limit | `GuestApi` policy — per-IP fixed window (`RateLimiting:GuestPermitLimit`) on IpLookup, Dns, Whois, Blacklist, IpTools |
| Auth brute-force mitigation | `AuthSensitive` policy — login/register/forgot/reset POST under `/api/v1/Users` |
| Authenticated bypass | Guest limit skipped when `User.Identity.IsAuthenticated` |
| HTTPS / HSTS | `UseHttpsRedirection`; `UseHsts` in non-Development |
| Security headers | `SecurityHeadersMiddleware`: `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy`, `Permissions-Policy` |
| CORS | Explicit origins via `Cors:AllowedOrigins`; Development allows any origin without credentials wildcard in prod config |
| JWT | `Jwt:BearerTokenExpirationHours` in appsettings |
| Hangfire | Development only; `LocalRequestsOnlyAuthorizationFilter` |
| Health endpoints | Development only (`MapDefaultEndpoints`) |

## Configuration (`appsettings.json`)

```json
"RateLimiting": {
  "GuestPermitLimit": 60,
  "GuestWindowMinutes": 1,
  "AuthPermitLimit": 10,
  "AuthWindowMinutes": 5
}
```

## Verification

- Functional: `tests/Application.FunctionalTests/Security/RateLimitingApiTests.cs`
- Dependency scan: `.\scripts\security-audit.ps1`
- Secret scan: Gitleaks in CI (`build.yml`, informational)
- Post-deploy: `.\scripts\post-deploy-smoke.ps1` (local/compose)
- Staging/prod URL: `.\scripts\staging-smoke.ps1` or workflow `staging-smoke.yml`

## Pre-release checklist (manual)

- [ ] Production `Cors:AllowedOrigins` set (no open CORS)
- [ ] Secrets in Key Vault / env, not in repo
- [ ] Scalar/Swagger exposure reviewed for Production
- [ ] TLS certificates valid
- [ ] Run `security-audit.ps1 -FailOnVulnerabilities` before release

## Deferred

- Account lockout after N failures (Identity lockout options)
- Content-Security-Policy tuned for Angular inline requirements
- DAST (OWASP ZAP) on staging
- PII masking audit in structured logs
