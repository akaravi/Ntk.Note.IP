# Cursor Plan — Ntk.Note.IP (Stage S2)

منبع: `plan.prompt/IPNote.plan.prompt.json` — Part 3 / Stage S2

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S2",
    "part": "Part 4",
    "updatedAt": "2026-05-29T12:05:00+03:30",
    "previousPart": "Cursor.3.plan.md (Stage S1)"
  },
  "Part 4": {
    "title": "Stage S2 — Domain IP + API IpNotes",
    "goal": "مدل‌سازی دامنه IP و API اولیه با envelope استاندارد"
  },
  "Result 4": {
    "summary": "Core S2 batch: IpAddress value object (v4/v6, scope, UInt32 round-trip), GeoLocation/AsnInfo VOs, IpRecord entity, domain events, full IpNotes CQRS + REST endpoints with ErrorExceptionResult envelope.",
    "domain": {
      "valueObjects": ["IpAddress", "GeoLocation", "AsnInfo"],
      "enums": ["IpAddressScope", "DeviceType", "NetworkType", "ConnectionType"],
      "entities": ["IpRecord (new)", "IpNote (existing)", "IpLookupRecord (existing)"],
      "events": ["IpChangedEvent", "NewConnectionDetectedEvent"]
    },
    "api": {
      "baseRoute": "/api/IpNotes",
      "endpoints": [
        "GET GetList — data: IpNoteDto[]",
        "GET GetOne/{id}",
        "POST Add",
        "PUT Update/{id}",
        "DELETE Delete/{id}"
      ],
      "envelope": "ErrorExceptionResult<T> with isSuccess, errorCode, errorMessage, data"
    },
    "tests": {
      "domainIpAddress": 5,
      "functionalIpNotes": 2,
      "totalPipeline": 43
    },
    "deferred": [
      "S2-008 Cidr VO",
      "S2-025 Tag entity M2M",
      "S2-026 IpHistory aggregate",
      "ActionLookup IP external provider (Stage S3+)"
    ],
    "nextStage": "S3 — Infrastructure providers, ActionLookup, IpLookupRecord pipeline"
  }
}
```
