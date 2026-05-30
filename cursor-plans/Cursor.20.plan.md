# Cursor Plan — Ntk.Note.IP (Stage S6 batch 1)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "stage": "S6",
    "part": "Part 20",
    "updatedAt": "2026-05-30T01:00:00+03:30",
    "previousPart": "Cursor.19.plan.md"
  },
  "Part 20": {
    "title": "Stage S6 — SPA hero, i18n toggle, design tokens, QR/local IP",
    "goal": "S6-001–S6-012 subset: semantic tokens, fa/en locale, IP hero UX, Vazirmatn, footer"
  },
  "Result 20": {
    "summary": "Angular IP lookup hero (large IP, IPv4/6 badge, local IP via WebRTC, copy + QR); I18nService locale from localStorage + nav toggle; design-tokens.scss; qrcode package; ADR-016.",
    "frontend": {
      "tokens": "src/Web/ClientApp/src/design-tokens.scss",
      "services": [
        "core/i18n.service.ts (ipnote.locale)",
        "core/local-ip.service.ts",
        "core/qr-code.service.ts"
      ],
      "ui": [
        "ip-lookup hero card",
        "nav language toggle",
        "app footer",
        "index.html IPNote.ir + Vazirmatn"
      ],
      "i18nKeys": 77,
      "newKeys": [
        "IP.COPY",
        "IP.COPIED",
        "IP.IPV4",
        "IP.IPV6",
        "IP.LOCAL_IP",
        "IP.LOCAL_IP_UNAVAILABLE",
        "IP.QR_SHOW",
        "IP.QR_HIDE",
        "IP.QR_ALT",
        "LANG.SWITCH"
      ]
    },
    "tests": { "totalPipeline": 54 },
    "docs": ["docs/decisions/ADR-016-Angular-SPA-Frontend.md"],
    "deferred": [
      "S6-019 browser history localStorage",
      "S6 map/device card/curl tabs",
      "PWA",
      "E2E Playwright"
    ],
    "nextStage": "S6 batch 2 — local IP history, polish language UX, map snippet"
  }
}
```
