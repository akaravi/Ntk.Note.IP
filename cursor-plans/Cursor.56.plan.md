# Cursor Plan — Ntk.Note.IP (Post-S9 Part 56)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "Post-S9",
    "part": "Part 56",
    "updatedAt": "2026-05-30T20:00:00+03:30",
    "previousPart": "Cursor.55.plan.md"
  },
  "Part 56": {
    "title": "Retrofit IpnoteClient + UX polish",
    "goal": "Wire IpLookup/IpNotes datasources to generated IpnoteClient; OpenApiEnvelope helper; haptics on copy/login; Android notification permission before background monitor"
  },
  "Result 56": {
    "summary": "ipnoteClientProvider; IpLookupRemoteDataSource + IpNotesRemoteDataSource use retrofit; OpenApiEnvelope; AppHaptics; notification permission UX; openapi_envelope_test (17 Flutter tests green).",
    "paths": {
      "client": "lib/presentation/providers/ipnote_client_provider.dart",
      "envelope": "lib/core/network/openapi_envelope.dart",
      "haptics": "lib/core/feedback/app_haptics.dart"
    },
    "deferred": [
      "Auth datasource via IpnoteClient login endpoint",
      "FCM push for IP change",
      "in_app_review prompt"
    ],
    "nextStage": "Auth retrofit + in-app review or Stage S7 close checklist"
  }
}
```
