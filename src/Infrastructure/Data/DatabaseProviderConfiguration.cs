using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using Microsoft.Extensions.DependencyInjection;
using Ntk.Note.IP.Infrastructure.Data.Interceptors;

namespace Ntk.Note.IP.Infrastructure.Data;

public static class DatabaseProviderConfiguration
{
    public static bool IsPostgreSql(string? provider) =>
        string.Equals(provider, "PostgreSQL", StringComparison.OrdinalIgnoreCase);

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
        else
        {
            options.UseSqlite(connectionString);
        }
    }
}
