using System.Net;
using System.Net.Http.Json;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Hosting;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.FunctionalTests.Security;

[TestFixture]
[NonParallelizable]
public class RateLimitingApiTests
{
    [Test]
    public async Task GuestApiShouldReturn429WhenPermitLimitExceeded()
    {
        await using var factory = CreateFactory(guestPermitLimit: 2);
        using var client = factory.CreateClient();

        for (var i = 0; i < 2; i++)
        {
            var ok = await client.GetAsync("/api/v1/IpLookup/GetMyIp");
            ok.StatusCode.ShouldBe(HttpStatusCode.OK);
        }

        var limited = await client.GetAsync("/api/v1/IpLookup/GetMyIp");
        limited.StatusCode.ShouldBe(HttpStatusCode.TooManyRequests);
    }

    [Test]
    public async Task AuthLoginShouldReturn429AfterRepeatedFailures()
    {
        await using var factory = CreateFactory(authPermitLimit: 2);
        using var client = factory.CreateClient();

        for (var i = 0; i < 2; i++)
        {
            var attempt = await client.PostAsJsonAsync(
                "/api/v1/Users/login",
                new { email = "nobody@test.local", password = "wrong" });
            attempt.StatusCode.ShouldBeOneOf(HttpStatusCode.Unauthorized, HttpStatusCode.BadRequest);
        }

        var limited = await client.PostAsJsonAsync(
            "/api/v1/Users/login",
            new { email = "nobody@test.local", password = "wrong" });
        limited.StatusCode.ShouldBe(HttpStatusCode.TooManyRequests);
    }

    [Test]
    public async Task ResponsesShouldIncludeSecurityHeaders()
    {
        await using var factory = CreateFactory();
        using var client = factory.CreateClient();

        var response = await client.GetAsync("/api/v1/IpLookup/GetMyIp");
        response.Headers.TryGetValues("X-Content-Type-Options", out var values).ShouldBeTrue();
        values!.ShouldContain("nosniff");
    }

    private static WebApiFactory CreateFactory(int? guestPermitLimit = null, int? authPermitLimit = null)
    {
        return new LimitedRateWebApiFactory(FunctionalTestSetup.ConnectionString, guestPermitLimit, authPermitLimit);
    }

    private sealed class LimitedRateWebApiFactory(
        string connectionString,
        int? guestPermitLimit,
        int? authPermitLimit) : WebApiFactory(connectionString)
    {
        protected override void ConfigureWebHost(Microsoft.AspNetCore.Hosting.IWebHostBuilder builder)
        {
            base.ConfigureWebHost(builder);
            ConfigureProductionTestHost(builder);

            if (guestPermitLimit.HasValue)
            {
                builder.UseSetting("RateLimiting:GuestPermitLimit", guestPermitLimit.Value.ToString());
            }

            if (authPermitLimit.HasValue)
            {
                builder.UseSetting("RateLimiting:AuthPermitLimit", authPermitLimit.Value.ToString());
                builder.UseSetting("RateLimiting:AuthWindowMinutes", "5");
            }
        }
    }
}
