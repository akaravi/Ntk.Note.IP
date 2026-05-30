# Cursor Plan — Ntk.Note.IP (Stage S8 close)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S8",
    "part": "Part 37",
    "updatedAt": "2026-05-30T19:45:00+03:30",
    "previousPart": "Cursor.36.plan.md",
    "stageStatus": "closed-subset"
  },
  "Part 37": {
    "title": "Stage S8 — Security baseline + formal close",
    "goal": "Auth rate limit; security headers; tests; security-audit.ps1; S8 DoD sign-off"
  },
  "Result 37": {
    "summary": "AuthSensitive rate limit on Users identity routes; SecurityHeadersMiddleware; RateLimitingApiTests; docs/security/security-baseline.md; scripts/security-audit.ps1. Stage S8 core quality track complete.",
    "security": {
      "rateLimit": ["GuestApi (existing)", "AuthSensitive login/register/forgot/reset"],
      "headers": ["X-Content-Type-Options", "X-Frame-Options", "Referrer-Policy", "Permissions-Policy"],
      "tests": "RateLimitingApiTests (3)",
      "auditScript": "scripts/security-audit.ps1"
    },
    "s8Completed": [
      "Test pyramid docs",
      "Coverlet 40% CI gate",
      "IP edge-case tests",
      "Playwright E2E (6)",
      "k6 smoke + CI workflow",
      "Flutter CI",
      "Security baseline subset"
    ],
    "s8Remaining": [
      "Testcontainers",
      "OpenAPI contract tests",
      "DAST/ZAP",
      "Coverlet 50%+",
      "Full privacy/GDPR automation",
      "axe accessibility CI"
    ],
    "verification": {
      "functional": "29 passed (incl. RateLimitingApiTests x3)",
      "build": "build.ps1 green"
    },
    "nextStage": "Production deployment hardening or post-S8 backlog"
  }
}
```
