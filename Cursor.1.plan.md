# Cursor Plan — Ntk.Note.IP

```json
{
  "metadata": {
    "project": "Ntk.Note.IP",
    "updatedAt": "2026-05-29T10:58:00+03:30"
  },
  "Part 1": {
    "title": "Project review and run all",
    "commands": [
      "Review solution structure (Clean Architecture + Aspire + Angular)",
      "dotnet build Ntk.Note.IP.sln -c Debug",
      "npm install in src/Web/ClientApp",
      "dotnet run --project src/AppHost --launch-profile https",
      "Health checks on /health and /alive",
      "SSL dev certificate verification"
    ]
  },
  "Result 1": {
    "summary": "Template symbols (#if UsePostgreSQL etc.) were not instantiated; SQLite package refs were inside XML comments. Fixed for SQLite + Angular stack. NuGet audit blocked restore — NuGetAudit=false in Directory.Build.props. Full solution builds. AppHost running via Aspire.",
    "architecture": {
      "layers": ["Domain", "Application", "Infrastructure", "Web", "AppHost", "ServiceDefaults"],
      "database": "SQLite (Aspire AddSqlite)",
      "frontend": "Angular 21 in src/Web/ClientApp",
      "orchestration": ".NET Aspire 13.2"
    },
    "build": {
      "status": "success",
      "notes": ["NU190x suppressed via NuGetAudit=false until package updates"]
    },
    "running": {
      "aspireDashboard": "https://127.0.0.1:17000",
      "aspireDashboardLogin": "https://cleanarchitecture.dev.localhost:17000/login?t=a065d5d4da78db09f892cd95a72882a3",
      "webApiHttp": "http://127.0.0.1:5000",
      "webApiHttps": "https://127.0.0.1:5001",
      "scalar": "https://127.0.0.1:5001/scalar",
      "webFrontendProxy": "http://127.0.0.1:50840",
      "angularDevPort": 49656,
      "otlp": "https://127.0.0.1:21000"
    },
    "healthChecks": [
      { "url": "https://127.0.0.1:5001/health", "status": 200 },
      { "url": "https://127.0.0.1:5001/alive", "status": 200 },
      { "url": "http://127.0.0.1:5000/health", "status": 307, "note": "redirects to HTTPS" }
    ],
    "ssl": {
      "devCertTrusted": true,
      "note": "Use 127.0.0.1 or trust dev cert; cleanarchitecture.dev.localhost may need hosts/DNS"
    },
    "logs": {
      "errors": "none in AppHost console after start",
      "warnings": "npm audit vulnerabilities in ClientApp (transitive)"
    },
    "filesChanged": [
      "Directory.Build.props",
      "Directory.Packages.props",
      "src/AppHost/Program.cs",
      "src/AppHost/AppHost.csproj",
      "src/Infrastructure/Infrastructure.csproj",
      "src/Infrastructure/DependencyInjection.cs",
      "src/Web/Program.cs",
      "tests/TestAppHost/TestAppHost.csproj",
      "tests/TestAppHost/Program.cs"
    ]
  }
}
```
