# Database backup and restore

## SQLite (current production sample)

The compose sample stores the file on volume `ipnote-data` at `/data/ipnote.db` inside the container.

### Backup (host / dev)

```powershell
.\scripts\backup-database.ps1
# output: artifacts\backup\Ntk.Note.IP-YYYYMMDD-HHmmss.db
```

Custom path:

```powershell
.\scripts\backup-database.ps1 -ConnectionString "Data Source=/data/ipnote.db" -OutputDir D:\backups\ipnote
```

From a running Docker volume:

```bash
docker compose -f docker-compose.prod.yml exec web cat /data/ipnote.db > ipnote-backup.db
# or stop web and copy volume:
docker run --rm -v ipnote-data:/data -v $(pwd):/backup alpine cp /data/ipnote.db /backup/ipnote.db
```

### Restore

1. Stop the Web app / `docker compose down` (web only).
2. Restore file:

```powershell
.\scripts\restore-database.ps1 -BackupFile artifacts\backup\Ntk.Note.IP-20260530-120000.db -Force
```

3. Start stack and run smoke: `.\scripts\post-deploy-smoke.ps1`.

### Schedule (production)

| Frequency | Action |
|-----------|--------|
| Daily | Automated file copy or volume snapshot |
| Weekly | Restore drill to a non-prod host (verify backup integrity) |
| Before release | Manual backup + tag note in release checklist |

Store backups off-server (object storage) with encryption at rest.

## PostgreSQL

When `Database:Provider=PostgreSQL` (see `docker-compose.prod.postgresql.yml`):

```powershell
$env:ConnectionStrings__IPNoteDb = "Host=...;Port=5432;Database=ipnote;Username=...;Password=..."
.\scripts\backup-database-postgresql.ps1
```

Or with `pg_dump` directly:

```bash
pg_dump -Fc -h HOST -U USER -d ipnote -f ipnote-$(date +%Y%m%d).dump
```

Restore:

```bash
pg_restore -d ipnote -c ipnote-YYYYMMDD.dump
```

Test recovery quarterly (S9-027 / DR drill).

## Migrations vs backup

- **Backup** = point-in-time data copy.
- **Migrations** = schema forward (`dotnet ef database update`, `migrate-idempotent.ps1`).

Always backup before applying migrations on production.

## Related

- [rollback.md](rollback.md)
- [production-deploy.md](production-deploy.md)
- [observability-baseline.md](../observability/observability-baseline.md)
