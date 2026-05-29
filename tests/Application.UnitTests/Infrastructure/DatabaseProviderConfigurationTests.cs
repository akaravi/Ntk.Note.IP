using Ntk.Note.IP.Infrastructure.Data;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.Infrastructure;

public class DatabaseProviderConfigurationTests
{
    [TestCase("PostgreSQL", true)]
    [TestCase("postgresql", true)]
    [TestCase("Sqlite", false)]
    [TestCase("SQLite", false)]
    [TestCase(null, false)]
    public void IsPostgreSql_Should_Match_Provider(string? provider, bool expected)
    {
        DatabaseProviderConfiguration.IsPostgreSql(provider).ShouldBe(expected);
    }
}
