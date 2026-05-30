{
  "metadata": {
    "title": "Cursor.93 — IP note device-info readonly box + friendlier timestamp",
    "updatedAt": "2026-05-30T20:15:00+03:30"
  },
  "Part 1": {
    "request": "In the IP note feature show a readonly box with device/browser specs (browser, OS, device type, browser language). Persist in DB and show on later retrieval. Make the date/time bigger and clearer, with relative time (hours/minutes ago) within one day for a user-friendly view.",
    "findings": [
      "Backend already persists DeviceInfoJson (browser, os, deviceType, language, label, userAgent) and returns DeviceInfo via IpNoteMappingProfile -> no schema/contract change needed.",
      "Web Angular notes page only rendered deviceLabel and a short muted timestamp.",
      "Flutter IpNote model parsed only deviceLabel, not the full deviceInfo object."
    ],
    "actions": [
      "Web: ip-notes.component.ts adds deviceRows() + relative/absolute timestamp helpers using Intl.RelativeTimeFormat.",
      "Web: ip-notes.component.html shows readonly device box in add form (when snapshot ready) and per saved note; prominent time block.",
      "Web: ip-notes.component.scss styles device box + time using semantic theme tokens (light/dark, RTL).",
      "Web: add IP.NOTE_WHEN + IP.NOTE_DEVICE_CAPTURED keys to fa.json and en.json (DEVICE.* already existed).",
      "Flutter: ip_note.dart parses deviceInfo; ip_notes_screen shows DeviceInfoCard-style readonly box + relative time."
    ]
  },
  "Result 1": {
    "status": "done",
    "backend": "No change required — DeviceInfoJson is already persisted and IpNoteDto.DeviceInfo is returned for every note, so later retrievals already carry browser/os/deviceType/language.",
    "web": [
      "ip-notes.component.ts: isRecent/noteWhenPrimary/noteWhenExact/relativeWhen (Intl.RelativeTimeFormat) + deviceRows/formDeviceRows helpers.",
      "ip-notes.component.html: readonly device box in add form (when snapshot ready) and per saved note; prominent two-line time block (relative + exact within a day, full date otherwise).",
      "ip-notes.component.scss: .ip-notes__when + .ip-notes__device styles using semantic tokens, RTL-safe, single-column grid on mobile.",
      "i18n fa.json + en.json: added IP.NOTE_JUST_NOW (DEVICE.* keys already existed)."
    ],
    "flutter": [
      "ip_note.dart: new IpNoteDeviceInfo value object parsed from deviceInfo JSON.",
      "ip_notes_screen.dart: _DeviceInfoBox readonly card + bigger relative timestamp (_relativeWhen).",
      "ARB fa/en/fr/ar: noteRecordedAt/noteJustNow/noteMinutesAgo/noteHoursAgo; regenerated app_localizations."
    ],
    "verification": [
      "Angular: npx ng build --configuration development => success.",
      "Flutter: flutter analyze (changed files) => No issues found.",
      "ReadLints on web component => clean; Persian/Arabic read-back => UTF-8 OK."
    ]
  }
}
