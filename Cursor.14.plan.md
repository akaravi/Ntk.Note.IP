# Cursor Plan — Ntk.Note.IP (Stage S4 batch 4)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S4",
    "part": "Part 14",
    "updatedAt": "2026-05-29T21:30:00+03:30",
    "previousPart": "Cursor.13.plan.md"
  },
  "Part 14": {
    "title": "Stage S4 — EF migrations + IpNote soft delete",
    "goal": "S4-015/016, S4-010 soft delete, ADR-009"
  },
  "Result 14": {
    "summary": "InitialIpNoteSchema migration; MigrateAsync on dev startup; IpNote.IsSoftDeleted + query filter; scripts/migrate-database.ps1.",
    "database": {
      "migrations": "Infrastructure/Data/Migrations/20260529091153_InitialIpNoteSchema.cs",
      "startup": "Database.MigrateAsync() replaces EnsureDeleted/EnsureCreated",
      "script": "scripts/migrate-database.ps1"
    },
    "domain": {
      "ipNoteSoftDelete": "DeleteIpNote sets IsSoftDeleted; global query filter on IpNotes"
    },
    "docs": ["docs/decisions/ADR-009-EF-Migrations.md"],
    "tests": { "totalPipeline": 73, "new": ["ShouldSoftDeleteWithoutPhysicalRemove"] },
    "nextStage": "UserId scoping on IpNotes or Stage S5"
  }
}
```
