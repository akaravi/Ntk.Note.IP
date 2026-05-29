namespace Ntk.Note.IP.Application.Common.Options;

public class DatabaseOptions
{
    public const string SectionName = "Database";

    public string Provider { get; set; } = "Sqlite";

    /// <summary>
    /// When true, applies EF migrations (and seed) on application startup — required for Production SQL Server unless you run migrate-database.ps1 manually.
    /// </summary>
    public bool ApplyMigrationsOnStartup { get; set; }
}
