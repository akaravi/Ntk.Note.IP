# Cursor Plans — Ntk.Note.IP

Agent execution history and JSON Prompt plans for this repository.

## Location

All plan files live in this folder:

- `cursor-plans/Cursor.1.plan.md` … `cursor-plans/Cursor.N.plan.md`

Each file documents one **Part** (commands run, results, next steps). New parts continue the sequence from the latest file.

## Format

- Markdown wrapper with a JSON Prompt block (`metadata`, `Part N`, `Result N`).
- `previousPart` in metadata links to the prior plan file (same folder, filename only).

## Related

- `plan.prompt/IPNote.plan.prompt.json` — master feature/stage catalog
- `docs/plan-implementation-audit.md` — implementation audit vs plans
- `readmehistory.md` — chronological change log at repo root
