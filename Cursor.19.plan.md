# Cursor Plan — Ntk.Note.IP (Stage S5 batch 4)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S5",
    "part": "Part 19",
    "updatedAt": "2026-05-30T00:00:00+03:30",
    "previousPart": "Cursor.18.plan.md"
  },
  "Part 19": {
    "title": "Stage S5 — JWT Bearer + auth middleware + production CORS",
    "goal": "Dual cookie/bearer auth for web and Flutter; UseAuthentication; domain IpAddress tests"
  },
  "Result 19": {
    "summary": "Smart auth scheme (cookie or Bearer); Jwt:BearerTokenExpirationHours; UseAuthentication/UseAuthorization; appsettings.Production.json CORS; ADR-015.",
    "auth": {
      "web": "Cookie via Identity.Application (useCookies=true on login)",
      "api": "Bearer via Identity.Bearer (POST /api/v1/Users/login JSON tokens)",
      "smartScheme": "Smart forwards Bearer header to Identity.Bearer"
    },
    "config": {
      "Jwt": "BearerTokenExpirationHours (1 dev, 24 production sample)",
      "CorsProduction": "https://ipnote.ir, https://www.ipnote.ir"
    },
    "tests": {
      "totalPipeline": 54,
      "new": [
        "BearerTokenShouldAuthorizeIpNotesEndpoint",
        "IpAddressTests (8 cases)"
      ]
    },
    "docs": ["docs/decisions/ADR-015-Dual-Auth-Cookie-And-Bearer.md"],
    "nextStage": "Stage S6 or run-all verification; optional refresh-token rotation hardening"
  }
}
```
