# Change History — Ntk.Note.IP

## 2026-05-29 10:58 (Asia/Tehran)

- **Run all / project review:** Instantiated Clean Architecture template for SQLite + Angular; enabled `Microsoft.EntityFrameworkCore.Sqlite` and `CommunityToolkit.Aspire.Hosting.SQLite` package references; removed unresolved `#if` template blocks from AppHost, Infrastructure, Web, TestAppHost.
- **Build:** Set `NuGetAudit=false` in `Directory.Build.props` to unblock restore (transitive OpenTelemetry / System.Security.Cryptography.Xml advisories).
- **Run:** Started Aspire AppHost (`https` profile); verified Web API health (`/health`, `/alive` → 200) and frontend proxy (`http://127.0.0.1:50840` → 200).
- **Docs:** Added `Cursor.1.plan.md` with JSON Prompt result block.
