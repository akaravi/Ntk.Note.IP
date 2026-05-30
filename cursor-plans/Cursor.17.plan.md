# Cursor Plan — Ntk.Note.IP (Stage S5 batch 2)



```json

{

  "metadata": {

    "project": "IPNote.ir",

    "stage": "S5",

    "part": "Part 17",

    "updatedAt": "2026-05-29T23:00:00+03:30",

    "previousPart": "Cursor.16.plan.md"

  },

  "Part 17": {

    "title": "Stage S5 — /api/v1 + template endpoint removal",

    "goal": "Versioned API prefix, legacy rewrite, remove Todo/Weather endpoints, ProblemDetails instance"

  },

  "Result 17": {

    "summary": "ApiRoutes /api/v1; UseRewriter legacy /api/* → /api/v1/*; removed TodoLists/TodoItems/WeatherForecasts endpoints; Angular template routes removed; ProblemDetails.Instance set.",

    "api": {

      "prefix": "/api/v1/{Group}",

      "legacy": "/api/* rewritten to /api/v1/*"

    },

    "removed": ["Web/Endpoints/TodoItems", "TodoLists", "WeatherForecasts", "Angular weather/todo/counter routes"],

    "docs": ["docs/decisions/ADR-012-Api-V1-Versioning.md"],

    "tests": {

      "totalPipeline": 76,

      "new": ["LegacyApiPathShouldRewriteToV1"]

    },

    "nextStage": "S5 batch 3: regenerate NSwag client cleanup, remove Todo domain when outbox test migrated, JWT/CORS polish"

  }

}

```


