# ADR-011: GetMyIpPlain text endpoint

## Status

Accepted

## Context

CLI tools and scripts need the caller IP without parsing JSON envelopes.

## Decision

- Add `GET /api/IpLookup/GetMyIpPlain` returning `text/plain` body with the address only.
- Add short alias `GET /myIp` (same handler, guest rate limit).
- Reuse `GetMyIpQuery` (same resolver as `GetMyIp`).

## Consequences

- `curl http://host/api/IpLookup/GetMyIpPlain` prints the IP directly.
- Angular exposes a copy-to-clipboard action on the IP lookup page.
