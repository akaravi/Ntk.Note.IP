# ADR-017: PWA manifest and optional service worker

## Status

Accepted (2026-05-30)

## Context

IPNote.ir SPA should be installable on mobile/desktop and degrade gracefully when offline.

## Decision

- Ship `manifest.webmanifest` with theme colors aligned to Pico violet palette.
- Register a minimal `sw.js` that caches shell assets and serves `offline.html` on network failure.
- No `@angular/service-worker` package; keep build simple and let Web project publish static `sw.js` from ClientApp assets.

## Consequences

- Install prompt support varies by browser; core app still requires API for lookups.
- Service worker is best-effort in development (ng serve) and fully active when served from `Web` static files.
