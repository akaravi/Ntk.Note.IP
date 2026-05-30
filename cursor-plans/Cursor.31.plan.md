# Cursor Plan — Ntk.Note.IP (Stage S7 batch 6)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S7",
    "part": "Part 31",
    "updatedAt": "2026-05-30T12:30:00+03:30",
    "previousPart": "Cursor.30.plan.md"
  },
  "Part 31": {
    "title": "Stage S7 — CLI curl tabs, tools compare, 60s IP poll",
    "goal": "S7-020 curl tabs; S7-027 compare subset; /tools route; live GetMyIp poll every 60s"
  },
  "Result 31": {
    "summary": "CurlCommandsCard on home (Linux/Mac/Win/PowerShell/MikroTik) using GetMyIpPlain URL; /tools with two-IP compare table; Timer.periodic 60s IP change detection on home.",
    "flutter": {
      "cli": "lib/core/cli/curl_command_snippets.dart + CurlCommandsCard",
      "tools": {
        "route": "/tools",
        "features": ["hub link to home", "compare two IPs via GetIpDetails"]
      },
      "livePoll": "60s GetMyIp — reload details when public IP changes",
      "l10nKeysAdded": 20
    },
    "quality": {
      "dartAnalyze": "no issues",
      "flutterTest": "1 passed"
    },
    "deferred": [
      "S7-029 ping/traceroute (no API yet)",
      "WHOIS/DNS/port tools on mobile (web focus= scroll)",
      "Drift migration",
      "CI flutter workflow"
    ],
    "nextStage": "S7 wrap-up: CI, README runbook, optional polish"
  }
}
```
