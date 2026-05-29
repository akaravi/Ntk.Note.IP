# Cursor Plan — Ntk.Note.IP (home hero + IP note snapshot)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 68",
    "updatedAt": "2026-05-29T21:30:00+03:30",
    "previousPart": "Cursor.67.plan.md"
  },
  "Part 68": {
    "title": "Home IP hero + یاداشت کن + snapshot metadata on IpNote",
    "goal": "Large IP on first page, small note button to ip-notes or login, full datetime/device/IP snapshot stored for list views",
    "requirements": [
      "Prominent IP on home (Angular ip-lookup, Flutter /)",
      "Small button «یاداشت کن» → /ip-notes?capture=1 or /login?returnUrl=…",
      "AddIpNote persists notedAtClient, timezone, local IP, device JSON, full IpDetails JSON",
      "List UI shows time, geo, device, ISP"
    ]
  },
  "Result 68": {
    "summary": "IpNote snapshot columns + migration; Angular/Flutter home hero and note flow; IpNoteSnapshotBuilder on clients.",
    "backend": [
      "Domain/Entities/IpNote.cs",
      "Application/IpNotes/IpNoteDto.cs",
      "Application/IpNotes/Commands/AddIpNote/AddIpNoteCommand.cs",
      "Infrastructure migration AddIpNoteSnapshotMetadata"
    ],
    "angular": [
      "ip-lookup hero + noteThisIp()",
      "core/ip-note-snapshot.builder.ts",
      "ip-notes capture=1 + metadata list"
    ],
    "flutter": [
      "home_screen _HeroCard displaySmall + noteThis",
      "core/ip_note_snapshot_builder.dart",
      "ip_notes captureSnapshot"
    ],
    "tests": "IpNoteTests.ShouldPersistSnapshotMetadataOnAdd (functional; env file lock if AppHost running)"
  }
}
```
