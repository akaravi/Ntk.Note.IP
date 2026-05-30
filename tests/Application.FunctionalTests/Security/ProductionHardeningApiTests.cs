using System.Net;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.FunctionalTests.Security;

[TestFixture]
[NonParallelizable]
public class ProductionHardeningApiTests
{
    [Test]
    public async Task ProductionShouldNotExposeApiDocumentationUi()
    {
        await using var factory = CreateProductionFactory();
        using var client = factory.CreateClient();

        var scalar = await client.GetAsync("/scalar");
        scalar.StatusCode.ShouldBe(HttpStatusCode.NotFound);
    }

    [Test]
    public async Task ProductionShouldExposeHealthEndpoints()
    {
        await using var factory = CreateProductionFactory();
        using var client = factory.CreateClient();

        var health = await client.GetAsync("/health");
        health.StatusCode.ShouldBe(HttpStatusCode.OK);

        var ready = await client.GetAsync("/health/ready");
        ready.StatusCode.ShouldBe(HttpStatusCode.OK);
    }

    [Test]
    public async Task ProductionShouldServePublicStatusPage()
    {
        await using var factory = CreateProductionFactory();
        using var client = factory.CreateClient();

        var statusPage = await client.GetAsync("/status.html");
        statusPage.StatusCode.ShouldBe(HttpStatusCode.OK);
        var html = await statusPage.Content.ReadAsStringAsync();
        html.ShouldContain("IPNote.ir");
    }

    [Test]
    public async Task ProductionShouldServeWellKnownAndChangelogAssets()
    {
        await using var factory = CreateProductionFactory();
        using var client = factory.CreateClient();

        (await client.GetAsync("/.well-known/assetlinks.json")).StatusCode.ShouldBe(HttpStatusCode.OK);
        (await client.GetAsync("/.well-known/apple-app-site-association")).StatusCode.ShouldBe(HttpStatusCode.OK);
        (await client.GetAsync("/changelog.html")).StatusCode.ShouldBe(HttpStatusCode.OK);
        (await client.GetAsync("/CHANGELOG.md")).StatusCode.ShouldBe(HttpStatusCode.OK);
    }

    private static WebApiFactory CreateProductionFactory()
    {
        return new ProductionWebApiFactory(FunctionalTestSetup.ConnectionString);
    }

    private sealed class ProductionWebApiFactory(string connectionString) : WebApiFactory(connectionString)
    {
        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            base.ConfigureWebHost(builder);
            ConfigureProductionTestHost(builder);
        }
    }
}
