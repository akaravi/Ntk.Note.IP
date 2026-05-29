using Microsoft.EntityFrameworkCore;
using Ntk.Note.IP.Infrastructure.Data;

namespace Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

/// <summary>
/// Ensures the Aspire/test SQLite database matches the latest EF migrations.
/// Repairs stale Aspire volumes without dropping the shared database file.
/// </summary>
internal static class TestDatabaseMigrator
{
    private static readonly SemaphoreSlim Gate = new(1, 1);
    private static bool _schemaReady;

    private const string SnapshotMigrationId = "20260529152256_AddIpNoteSnapshotMetadata";

    private static readonly Dictionary<string, string> IpNoteSnapshotAlterSql = new(StringComparer.Ordinal)
    {
        ["Asn"] = """ALTER TABLE "IpNotes" ADD COLUMN "Asn" TEXT NULL;""",
        ["City"] = """ALTER TABLE "IpNotes" ADD COLUMN "City" TEXT NULL;""",
        ["ClientTimezone"] = """ALTER TABLE "IpNotes" ADD COLUMN "ClientTimezone" TEXT NULL;""",
        ["CountryCode"] = """ALTER TABLE "IpNotes" ADD COLUMN "CountryCode" TEXT NULL;""",
        ["DeviceInfoJson"] = """ALTER TABLE "IpNotes" ADD COLUMN "DeviceInfoJson" TEXT NULL;""",
        ["DeviceLabel"] = """ALTER TABLE "IpNotes" ADD COLUMN "DeviceLabel" TEXT NULL;""",
        ["IpSnapshotJson"] = """ALTER TABLE "IpNotes" ADD COLUMN "IpSnapshotJson" TEXT NULL;""",
        ["Isp"] = """ALTER TABLE "IpNotes" ADD COLUMN "Isp" TEXT NULL;""",
        ["LocalIpAddress"] = """ALTER TABLE "IpNotes" ADD COLUMN "LocalIpAddress" TEXT NULL;""",
        ["NotedAtClient"] = """ALTER TABLE "IpNotes" ADD COLUMN "NotedAtClient" TEXT NULL;""",
        ["Region"] = """ALTER TABLE "IpNotes" ADD COLUMN "Region" TEXT NULL;""",
    };

    public static async Task EnsureLatestSchemaAsync(string connectionString, CancellationToken cancellationToken = default)
    {
        if (_schemaReady)
        {
            return;
        }

        await Gate.WaitAsync(cancellationToken);
        try
        {
            if (_schemaReady)
            {
                return;
            }

            await ApplySchemaAsync(connectionString, cancellationToken);
            _schemaReady = true;
        }
        finally
        {
            Gate.Release();
        }
    }

    public static void EnsureLatestSchema(string connectionString) =>
        EnsureLatestSchemaAsync(connectionString).GetAwaiter().GetResult();

    private static async Task ApplySchemaAsync(string connectionString, CancellationToken cancellationToken)
    {
        var options = new DbContextOptionsBuilder<ApplicationDbContext>()
            .UseSqlite(connectionString)
            .Options;

        await using var context = new ApplicationDbContext(options);

        await context.Database.MigrateAsync(cancellationToken);

        if (!await HasColumnAsync(context, "IpNotes", "Asn", cancellationToken))
        {
            await context.Database.ExecuteSqlRawAsync(
                $"DELETE FROM \"__EFMigrationsHistory\" WHERE \"MigrationId\" = '{SnapshotMigrationId}';",
                cancellationToken);

            await context.Database.MigrateAsync(cancellationToken);
        }

        await RepairIpNoteSnapshotColumnsAsync(context, cancellationToken);

        if (!await HasColumnAsync(context, "IpNotes", "Asn", cancellationToken))
        {
            throw new InvalidOperationException(
                "Test database schema is missing IpNotes.Asn after migration repair. " +
                "Verify migrations are included in the Infrastructure assembly.");
        }
    }

    private static async Task RepairIpNoteSnapshotColumnsAsync(
        ApplicationDbContext context,
        CancellationToken cancellationToken)
    {
        foreach (var (name, alterSql) in IpNoteSnapshotAlterSql)
        {
            if (await HasColumnAsync(context, "IpNotes", name, cancellationToken))
            {
                continue;
            }

            await context.Database.ExecuteSqlRawAsync(alterSql, cancellationToken);
        }
    }

    private static async Task<bool> HasColumnAsync(
        ApplicationDbContext context,
        string table,
        string column,
        CancellationToken cancellationToken)
    {
        var connection = context.Database.GetDbConnection();
        if (connection.State != System.Data.ConnectionState.Open)
        {
            await connection.OpenAsync(cancellationToken);
        }

        await using var command = connection.CreateCommand();
        command.CommandText = $"SELECT COUNT(*) FROM pragma_table_info('{table}') WHERE name = '{column}';";

        var result = await command.ExecuteScalarAsync(cancellationToken);
        return Convert.ToInt64(result) > 0;
    }
}
