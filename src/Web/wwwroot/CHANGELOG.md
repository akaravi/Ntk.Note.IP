# Changelog

All notable changes to IPNote.ir are documented here (public summary).

## [Unreleased]

## [0.1.1] — 2026-05-30

### Added
- Unified domain checks (Web + Flutter): one button runs WHOIS, DNS, propagation, port and SSL; tabbed results.
- Port-43 WHOIS fallback for TLDs without RDAP (e.g. `.ir` via `whois.nic.ir`).
- Public status page (`/status.html`) and changelog (`/changelog.html`).

### Fixed
- Flutter splash/bootstrap hang on web (auth/settings timeout, lazy router).
- WHOIS domain returned fake data when `Whois:Provider` was `Fake`; default is now RDAP + port-43 fallback.
- Domain input accepts full URLs (`https://example.com/path`).

### Changed
- Flutter mobile semver aligned with `version.json` (`0.1.1+2`).

## [0.1.0] — 2026-05-30

### Added
- App Link verification files under `/.well-known/`.
- PostgreSQL production provider and Hangfire PostgreSQL storage.
- GHCR image publish, deploy workflows, uptime monitoring.

### Changed
- DevOps runbooks, backup scripts, and CI migration verify for PostgreSQL.
- Stage S9 DevOps: CI/CD, Docker compose, staging smoke, observability baseline, on-call runbooks.

## 2026-05-29

- Flutter mobile app (IP lookup, auth, dashboard, notes, tools).
- Angular SPA: IP lookup, dashboard, tools, i18n (fa/en).
