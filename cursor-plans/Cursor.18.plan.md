# Cursor Plan — Ntk.Note.IP (Stage S5 batch 3)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S5",
    "part": "Part 18",
    "updatedAt": "2026-05-29T23:30:00+03:30",
    "previousPart": "Cursor.17.plan.md"
  },
  "Part 18": {
    "title": "Stage S5 — Remove Todo/Weather template + NSwag + CORS",
    "goal": "Full template removal, outbox test migration, configurable CORS"
  },
  "Result 18": {
    "summary": "Todo/Weather removed from Domain/Application/DB/UI; migration RemoveTodoTemplateTables; NSwag client regenerated; CorsOptions; ADR-013/014.",
    "removed": [
      "TodoList/TodoItem/Colour/PriorityLevel",
      "WeatherForecasts application",
      "Angular weather/todo/counter/fetch-data folders",
      "19 functional Todo tests"
    ],
    "database": { "migration": "RemoveTodoTemplateTables" },
    "client": "npm run generate-api — web-api-client.ts without Todo/Weather",
    "tests": { "totalPipeline": 45, "functional": 24, "applicationUnit": 18 },
    "nextStage": "S5 batch 4: JWT Bearer for Flutter, production CORS origins, optional Domain unit tests"
  }
}
```
