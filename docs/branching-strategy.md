# Git Branching Strategy — IPNote.ir

## Model

**Trunk-based (lightweight)** on `main`:

| Prefix | Use |
|--------|-----|
| `feature/*` | New capabilities |
| `fix/*` | Bug fixes |
| `release/*` | Release preparation |
| `chore/*` | Tooling, docs, CI |

## Rules

1. `main` is always buildable (`build.ps1` green).
2. Merge via Pull Request; no direct pushes to `main` in team workflow.
3. Conventional Commits encouraged: `feat:`, `fix:`, `docs:`, `chore:`.
4. One focused change per PR; align with plan subtask ID when possible (e.g. `feat(S1-012): add IpAddress entity`).

## Environments

| Branch / tag | Environment |
|--------------|-------------|
| `main` | Development integration |
| `release/*` | Staging |
| Tagged semver | Production |
