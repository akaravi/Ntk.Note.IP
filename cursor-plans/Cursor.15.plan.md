# Cursor Plan — Ntk.Note.IP (Stage S4 batch 5)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S4",
    "part": "Part 15",
    "updatedAt": "2026-05-29T22:00:00+03:30",
    "previousPart": "Cursor.14.plan.md"
  },
  "Part 15": {
    "title": "Stage S4 — IpNote per-user scope",
    "goal": "Tenant isolation via CreatedBy; ADR-010"
  },
  "Result 15": {
    "summary": "IpNoteUserScope filters all IpNote CRUD by IUser.Id (CreatedBy); indexes on CreatedBy; cross-user test.",
    "application": {
      "helper": "IpNoteUserScope.RequireUserId + OwnedBy extension",
      "handlers": "GetList, GetOne, Update, Delete scoped to current user"
    },
    "database": {
      "migration": "AddIpNoteUserIndexes"
    },
    "docs": ["docs/decisions/ADR-010-IpNote-User-Scope.md"],
    "tests": { "totalPipeline": 74, "new": ["ShouldNotAccessAnotherUsersNote"] },
    "nextStage": "Stage S5 API polish (GetMyIpPlain, /api/v1) or Angular auth for IpNotes"
  }
}
```
