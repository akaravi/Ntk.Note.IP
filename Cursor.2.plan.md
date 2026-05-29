# Cursor Plan — Ntk.Note.IP (Stage S0)

منبع: `plan.prompt/IPNote.plan.prompt.json` — Part 1 / Stage S0

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "solution": "Ntk.Note.IP",
    "stage": "S0",
    "part": "Part 2",
    "planRef": "plan.prompt/IPNote.plan.prompt.json",
    "updatedAt": "2026-05-29T11:15:00+03:30",
    "previousPart": "Cursor.1.plan.md (run all + template fix)"
  },
  "Part 2": {
    "title": "Stage S0 — محیط، ابزار، مخزن و کنوانسیون‌ها",
    "goal": "آماده‌سازی ماشین توسعه، بازرسی و تطبیق سورس واقعی، تثبیت استانداردهای کد",
    "commands": [
      "Verify dotnet/node/flutter/git/curl",
      "Audit solution structure vs IPNote plan",
      "dotnet restore/build/test",
      "Create ADR-004 API-First, ADR-005 SQLite",
      "Create docs/i18n fa+en, check-i18n-keys.ps1",
      "Create build.ps1, version.json, .env.example",
      "Create branching strategy + code review checklist",
      "Document gaps for S1"
    ]
  },
  "Result 2": {
    "summary": "Stage S0 started and core baseline completed. Dev toolchain verified (Docker missing). Solution builds; 33 unit/functional tests pass. Real structure documented; IPNote naming/entities not yet migrated (still Ntk.Note.IP template). Foundation docs, i18n base files, ADRs, and build script added.",
    "toolchain": {
      "dotnet": "10.0.204",
      "node": "v22.22.0",
      "npm": "11.6.2",
      "flutter": "3.41.7 stable",
      "docker": "not installed",
      "curl": "8.19.0",
      "gitBranch": "main",
      "gitStatus": "plan.prompt/ untracked"
    },
    "solutionProjects": [
      "AppHost", "Application", "Domain", "Infrastructure",
      "ServiceDefaults", "Shared", "Web",
      "Application.FunctionalTests", "Application.UnitTests",
      "Domain.UnitTests", "Infrastructure.IntegrationTests",
      "TestAppHost", "Web.AcceptanceTests"
    ],
    "targetFramework": "net10.0 (Directory.Build.props)",
    "architectureGap": {
      "currentNamespaces": "Ntk.Note.IP.*",
      "plannedNamespaces": "Ntk.Note.IP.* / IPNote domain",
      "currentEntities": ["TodoList", "TodoItem"],
      "plannedEntities": "IP notes, lookup history, geo/ASN (Stage S2+)",
      "flutterApp": "not scaffolded",
      "featureCatalog": "Cursor.01.plan.md (147 features) — pending creation"
    },
    "conventionsStatus": {
      "editorconfig": "exists — naming PascalCase/camelCase",
      "directoryBuildProps": "exists — Nullable, ImplicitUsings, TreatWarningsAsErrors, NuGetAudit=false",
      "directoryPackagesProps": "CPM enabled",
      "readmehistory": "exists",
      "githubWorkflows": "build.yml, codeql.yml exist",
      "docsAdr": "ADR-001..003 template + ADR-004/005 IPNote"
    },
    "buildTest": {
      "restore": "success",
      "build": "success (Debug)",
      "tests": {
        "Domain.UnitTests": "6 passed",
        "Application.UnitTests": "8 passed",
        "Application.FunctionalTests": "19 passed",
        "totalPassed": 33
      }
    },
    "artifactsCreated": [
      "Cursor.2.plan.md",
      "README-IPNote.fa.md",
      "version.json",
      ".env.example",
      "build.ps1",
      "scripts/check-i18n-keys.ps1",
      "docs/i18n/fa.json",
      "docs/i18n/en.json",
      "docs/architecture/ipnote-overview.md",
      "docs/decisions/ADR-004-API-First-IPNote.md",
      "docs/decisions/ADR-005-SQLite-Development-Database.md",
      "docs/branching-strategy.md",
      "docs/code-review-checklist.md"
    ],
    "subtasksProgress": {
      "completed": [
        "S0-001..002, S0-012..019",
        "S0-020, S0-023..026",
        "S0-034..035, S0-037..039",
        "S0-041..043, S0-046, S0-048, S0-058..059",
        "S0-074..077, S0-097, S0-099..100"
      ],
      "partial": [
        "S0-003..004 flutter installed, doctor not run",
        "S0-036 README-IPNote.fa.md (English README.md still template)",
        "S0-060..068 CI exists from template, not IPNote-customized"
      ],
      "blocked": [
        "S0-007 Docker not installed",
        "S0-052..057 docker-compose DB/Redis/Seq",
        "S0-064 flutter CI — no Flutter project yet"
      ],
      "deferred": [
        "S0-028..030 analyzers StyleCop/Roslynator",
        "S0-080..084 design tokens / brand assets",
        "S0-087..089 feature catalog mapping — needs Cursor.01.plan.md"
      ]
    },
    "nextStage": {
      "id": "S1",
      "part": "Part 3",
      "firstTasks": [
        "S1-001..010 scaffold/rename to Ntk.Note.IP.*",
        "S1-011+ dependency rules between layers",
        "Replace Todo sample with IP domain skeleton"
      ]
    }
  }
}
```
