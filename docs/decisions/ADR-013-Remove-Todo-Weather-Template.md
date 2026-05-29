# ADR-013: Remove ASP.NET template Todo/Weather stack

## Status

Accepted

## Context

The solution retained the Clean Architecture template Todo/Weather sample after IPNote features were added. It duplicated patterns, bloated OpenAPI/NSwag output, and seeded unrelated data.

## Decision

- Remove Todo/Weather domain, application handlers, EF tables (`RemoveTodoTemplateTables` migration), and Angular sample components.
- Keep outbox functional coverage via direct `IpChangedEvent` enqueue + `IOutboxProcessor`.
- Regenerate `web-api-client.ts` from OpenAPI (NSwag) without Todo/Weather clients.

## Consequences

- Smaller codebase and faster builds; IPNote entities only in persistence.
- Cookie Identity remains the primary web auth; JWT Bearer for mobile is a separate future ADR.
