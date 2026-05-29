using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.DependencyInjection;
using Ntk.Note.IP.Infrastructure.Data.Interceptors;

namespace Ntk.Note.IP.Infrastructure.Data;

public static class DatabaseProviderConfiguration
{
    public const string SqlServerMigrationsAssembly = "Ntk.Note.IP.Infrastructure.SqlServer";

    public static bool IsPostgreSql(string? provider) =>
        string.Equals(provider, "PostgreSQL", StringComparison.OrdinalIgnoreCase);

    public static bool IsSqlServer(string? provider) =>
        string.Equals(provider, "SqlServer", StringComparison.OrdinalIgnoreCase)
        || string.Equals(provider, "MSSQL", StringComparison.OrdinalIgnoreCase);

    internal static void ConfigureDbContext(
        DbContextOptionsBuilder options,
        string provider,
        string connectionString,
        IServiceProvider serviceProvider)
    {
        options.AddInterceptors(serviceProvider.GetServices<ISaveChangesInterceptor>());
        options.ConfigureWarnings(warnings => warnings.Ignore(RelationalEventId.PendingModelChangesWarning));

        if (IsPostgreSql(provider))
        {
            options.UseNpgsql(connectionString, npgsql =>
                npgsql.EnableRetryOnFailure(maxRetryCount: 3));
        }
        else if (IsSqlServer(provider))
        {
            options.UseSqlServer(connectionString, sql =>
            {
                sql.EnableRetryOnFailure(maxRetryCount: 3);
                sql.MigrationsAssembly(SqlServerMigrationsAssembly);
            });
        }
        else
        {
            options.UseSqlite(connectionString);
        }
    }
}
