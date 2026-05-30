using Microsoft.Extensions.Configuration;
using Ntk.Note.IP.Web.Infrastructure;
using NUnit.Framework;

namespace Ntk.Note.IP.Architecture.UnitTests.Infrastructure;

public class ClientsConfigurationExtensionsTests
{
    [Test]
    public void GetMergedCorsOrigins_MergesClientsAndLegacyCors()
    {
        var configuration = new ConfigurationBuilder()
            .AddInMemoryCollection(new Dictionary<string, string?>
            {
                ["Clients:panel-web:AllowedOrigins:0"] = "https://ipnote.ir",
                ["Clients:flutter-app:AllowedOrigins:0"] = "https://app.ipnote.ir",
                ["Cors:AllowedOrigins:0"] = "https://extra.example.com",
            })
            .Build();

        var origins = configuration.GetMergedCorsOrigins();

        Assert.That(origins, Has.Length.EqualTo(3));
        Assert.That(origins, Does.Contain("https://ipnote.ir"));
        Assert.That(origins, Does.Contain("https://app.ipnote.ir"));
        Assert.That(origins, Does.Contain("https://extra.example.com"));
    }
}
