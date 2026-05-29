# Cursor Plan — Ntk.Note.IP (SQL Server migrations)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 71",
    "updatedAt": "2026-05-29T21:10:00+03:30",
    "previousPart": "Cursor.70.plan.md"
  },
  "Part 71": {
    "title": "SQL Server schema — migrations + apply to NTK_IP_NOTE",
    "goal": "Create SQL Server–specific EF migrations and apply schema to remote MSSQL (s45.ntkhost.com / NTK_IP_NOTE)",
    "rootCauses": [
      "DatabaseProviderConfiguration had no UseSqlServer — SqlServer provider fell through to SQLite",
      "Existing migrations in Infrastructure are SQLite-specific (TEXT, INTEGER)",
      "ApplyMigrationsOnStartup in base appsettings caused OpenAPI build to migrate during compile"
    ],
    "changes": [
      "Infrastructure.SqlServer project with InitialIpNoteSchema migration",
      "DatabaseProviderConfiguration.UseSqlServer + MigrationsAssembly",
      "ApplicationDbContextFactory loads appsettings.{Environment}.json only",
      "Program.cs skips DB init during GetDocument OpenAPI generation",
      "ApplyMigrationsOnStartup only in Production (not base appsettings.json)",
      "scripts/migrate-database.ps1 selects SqlServer vs Sqlite project by provider"
    ],
    "commands": [
      "ASPNETCORE_ENVIRONMENT=Production dotnet ef migrations add InitialIpNoteSchema --project src/Infrastructure.SqlServer --startup-project src/Web",
      "ASPNETCORE_ENVIRONMENT=Production dotnet ef database update --project src/Infrastructure.SqlServer --startup-project src/Web"
    ]
  },
  "Result 71": {
    "summary": "Migration 20260529173609_InitialIpNoteSchema applied to NTK_IP_NOTE on s45.ntkhost.com. Tables include AspNetUsers/Roles, IpNotes, IpLookupRecords, IpRecords, OutboxMessages, PushDeviceRegistrations, UserPublicIpSnapshots. Web build succeeds. Production startup applies migrations via ApplyMigrationsOnStartup in appsettings.Production.json.",
    "devNote": "Local Development uses Sqlite (appsettings.Development.json). Production/Plesk uses SqlServer.",
    "migrateScript": "scripts/migrate-database.ps1 with ASPNETCORE_ENVIRONMENT=Production or Database__Provider=SqlServer"
  }
}
```
