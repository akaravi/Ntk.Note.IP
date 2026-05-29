# Cursor Plan — Ntk.Note.IP (Stage S5 batch 1)



```json

{

  "metadata": {

    "project": "IPNote.ir",

    "stage": "S5",

    "part": "Part 16",

    "updatedAt": "2026-05-29T22:30:00+03:30",

    "previousPart": "Cursor.15.plan.md"

  },

  "Part 16": {

    "title": "Stage S5 — GetMyIpPlain + Angular copy",

    "goal": "curl-friendly plain IP endpoint; UI copy button; ADR-011"

  },

  "Result 16": {

    "summary": "GET /api/IpLookup/GetMyIpPlain returns text/plain; Angular copy-to-clipboard; functional test; OpenAPI via Produces<string>.",

    "api": {

      "GetMyIpPlain": "GET /api/IpLookup/GetMyIpPlain — body: IP address only (text/plain)"

    },

    "angular": {

      "service": "ip-lookup.service.getMyIpPlain()",

      "ui": "copyPlainIp button on /ip-lookup with IP.PLAIN_TEXT / IP.PLAIN_COPIED i18n"

    },

    "docs": ["docs/decisions/ADR-011-GetMyIpPlain.md"],

    "tests": {

      "totalPipeline": 75,

      "new": ["GetMyIpPlainShouldReturnPlainTextAddress"]

    },

    "deferred": [

      "/api/v1 route prefix (duplicate WithName risk)",

      "IpNotes Angular auth UX beyond existing AuthGuard + AuthorizeInterceptor"

    ],

    "nextStage": "S5 batch 2: API versioning prefix, ProblemDetails polish, or template Todo/Weather removal"

  }

}

```


