# Cursor Plan — Ntk.Note.IP (Post-S9 Part 52)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 52",
    "updatedAt": "2026-05-30T16:00:00+03:30",
    "previousPart": "Cursor.51.plan.md"
  },
  "Part 52": {
    "title": "Flutter OpenAPI codegen (S7-006)",
    "goal": "swagger_parser for IpLookup/IpNotes/Users; committed lib/api/generated; openapi_mappers; repository wiring; sync + gen scripts; CI spec diff"
  },
  "Result 52": {
    "summary": "swagger_parser.yaml + 66 generated files; openapi_mappers.dart; IpLookup/IpNotes repos use generated DTO parsers; sync-openapi-spec.ps1 + flutter-openapi-gen.ps1; flutter-mobile.yml OpenAPI diff gate.",
    "scripts": [
      "scripts/sync-openapi-spec.ps1",
      "scripts/flutter-openapi-gen.ps1"
    ],
    "deferred": [
      "Migrate datasources to retrofit IpnoteClient (optional)",
      "Regenerate after every backend OpenAPI change in same PR"
    ],
    "nextStage": "Biometric login (local_auth) or Drift local DB"
  }
}
```
