using System.Net;
using Microsoft.AspNetCore.Hosting;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.FunctionalTests.Observability;

[TestFixture]
public class PrometheusMetricsApiTests
{
    [Test]
    public async Task MetricsEndpointShouldBeDisabledByDefault()
    {
        using var client = FunctionalTestSetup.HttpClient;

        var response = await client.GetAsync("/metrics");

        response.StatusCode.ShouldBe(HttpStatusCode.NotFound);
    }

    [Test]
    [NonParallelizable]
    public async Task MetricsEndpointShouldBeAvailableWhenEnabled()
    {
        var connectionString = $"Data Source=file:prom-metrics-{Guid.NewGuid():N}?mode=memory&cache=shared";
        await using var factory = new MetricsEnabledWebApiFactory(connectionString);
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/metrics");

        response.StatusCode.ShouldBe(HttpStatusCode.OK);
        var body = await response.Content.ReadAsStringAsync();
        body.ShouldContain("http_server");
    }

    private sealed class MetricsEnabledWebApiFactory(string connectionString) : WebApiFactory(connectionString)
    {
        protected override void ConfigureWebHost(IWebHostBuilder builder)
        {
            builder.UseSetting("OpenTelemetry:EnablePrometheusEndpoint", "true");
            base.ConfigureWebHost(builder);
        }
    }
}
