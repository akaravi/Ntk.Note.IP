# Cursor Plan — Ntk.Note.IP (Stage S1)

منبع: `plan.prompt/IPNote.plan.prompt.json` — Part 2 / Stage S1

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "solution": "Ntk.Note.IP",
    "stage": "S1",
    "part": "Part 3",
    "planRef": "plan.prompt/IPNote.plan.prompt.json",
    "updatedAt": "2026-05-29T11:45:00+03:30",
    "previousPart": "Cursor.2.plan.md (Stage S0)"
  },
  "Part 3": {
    "title": "Stage S1 — اسکلت Solution و معماری بک‌اند",
    "goal": "تطبیق ساختار لایه‌ای، مرزبندی وابستگی، زیرساخت مشترک IPNote",
    "commands": [
      "Rename CleanArchitecture → Ntk.Note.IP (namespaces + assemblies)",
      "Add IpNote, IpLookupRecord domain entities + EF configs",
      "Add ErrorExceptionResult, PagedResult, ErrorCodes",
      "Add Architecture.UnitTests (NetArchTest.Rules)",
      "build.ps1 green (36 tests)"
    ]
  },
  "Result 3": {
    "summary": "Stage S1 core batch completed. Full solution renamed to Ntk.Note.IP.* assemblies. IP domain skeleton (IpNote, IpLookupRecord) added to EF. Uniform API envelope types added. Layer dependency tests pass. Web remains API+SPA host (separate Api project deferred).",
    "rename": {
      "from": "CleanArchitecture.*",
      "to": "Ntk.Note.IP.*",
      "database": "IPNoteDb",
      "artifactsPath": "artifacts/bin/{Project}/debug/Ntk.Note.IP.*.dll"
    },
    "domainAdded": [
      "IpNote — user note on IP address",
      "IpLookupRecord — geo/ASN lookup history"
    ],
    "applicationAdded": [
      "ErrorExceptionResult<T> / ErrorExceptionResult",
      "PagedResult<T>",
      "ErrorCodes"
    ],
    "architectureTests": {
      "project": "tests/Architecture.UnitTests",
      "package": "NetArchTest.Rules 1.3.2",
      "testsPassed": 3,
      "rules": [
        "Domain must not reference Application/Infrastructure/Web",
        "Application must not reference Infrastructure/Web",
        "Auditable entities in Domain.Entities namespace"
      ]
    },
    "buildTest": {
      "build": "success",
      "tests": {
        "Architecture": 3,
        "Domain": 6,
        "Application": 8,
        "Functional": 19,
        "total": 36
      }
    },
    "deferredToS1Continued": [
      "S1-006 separate Ntk.Note.IP.Api project",
      "S1-032+ Serilog dedicated setup",
      "S1-042 API versioning",
      "CQRS handlers for IpNote/IpLookup",
      "Remove or migrate Todo sample"
    ],
    "nextStage": {
      "id": "S2",
      "focus": "IP lookup providers, GetList/GetOne API endpoints, Flutter scaffold"
    }
  }
}
```
