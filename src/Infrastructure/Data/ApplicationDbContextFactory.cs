using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Shared;

namespace Ntk.Note.IP.Infrastructure.Data;

/// <summary>
/// Design-time factory for <c>dotnet ef</c> (migrations, scripts). Reads Web appsettings + environment variables.
/// </summary>
public class ApplicationDbContextFactory : IDesignTimeDbContextFactory<ApplicationDbContext>
{
    public ApplicationDbContext CreateDbContext(string[] args)
    {
        var webRoot = ResolveWebProjectPath();
        var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";
        var configuration = new ConfigurationBuilder()
            .SetBasePath(webRoot)
            .AddJsonFile("appsettings.json", optional: false)
            .AddJsonFile($"appsettings.{environment}.json", optional: true)
            .AddEnvironmentVariables()
            .Build();

        var provider = configuration.GetValue<string>($"{DatabaseOptions.SectionName}:Provider") ?? "Sqlite";
        var connectionString = configuration.GetConnectionString(Services.Database)
            ?? throw new InvalidOperationException($"Connection string '{Services.Database}' not found.");

        var optionsBuilder = new DbContextOptionsBuilder<ApplicationDbContext>();
        optionsBuilder.ConfigureWarnings(w => w.Ignore(Microsoft.EntityFrameworkCore.Diagnostics.RelationalEventId.PendingModelChangesWarning));

        if (DatabaseProviderConfiguration.IsPostgreSql(provider))
        {
            optionsBuilder.UseNpgsql(connectionString);
        }
        else if (DatabaseProviderConfiguration.IsSqlServer(provider))
        {
            optionsBuilder.UseSqlServer(connectionString, sql =>
                sql.MigrationsAssembly(DatabaseProviderConfiguration.SqlServerMigrationsAssembly));
        }
        else
        {
            optionsBuilder.UseSqlite(connectionString);
        }

        return new ApplicationDbContext(optionsBuilder.Options);
    }

    private static string ResolveWebProjectPath()
    {
        var candidates = new[]
        {
            Path.Combine(Directory.GetCurrentDirectory(), "..", "Web"),
            Path.Combine(Directory.GetCurrentDirectory(), "..", "..", "Web"),
            Path.Combine(Directory.GetCurrentDirectory(), "src", "Web"),
        };

        foreach (var path in candidates)
        {
            var full = Path.GetFullPath(path);
            if (File.Exists(Path.Combine(full, "appsettings.json")))
            {
                return full;
            }
        }

        throw new InvalidOperationException("Could not locate Web project appsettings.json for design-time DbContext.");
    }
}
