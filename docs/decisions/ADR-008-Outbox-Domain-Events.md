# ADR-008: Outbox for domain events

## Status

Accepted

## Context

Publishing domain events inside `SaveChanges` couples transaction commit with MediatR handlers and loses messages if the process crashes after commit.

## Decision

- On save, when `Outbox:Enabled` is true, serialize domain events into `OutboxMessages` instead of immediate `IMediator.Publish`.
- `ProcessOutboxJob` (Hangfire, every minute) calls `IOutboxProcessor` to publish and mark rows processed.
- When `Outbox:Enabled` is false, keep synchronous publish (useful for isolated tests).

## Consequences

- Handlers run shortly after commit, not in-process.
- Failed handlers store `Error` on the outbox row for inspection.
