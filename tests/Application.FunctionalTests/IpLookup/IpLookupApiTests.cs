using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

namespace Ntk.Note.IP.Application.FunctionalTests.IpLookup;

public class IpLookupApiTests : TestBase
{
    [Test]
    public async Task GetMyIpPlainShouldReturnPlainTextAddress()
    {
        var body = await TestApp.GetHttpStringAsync("/api/v1/IpLookup/GetMyIpPlain");
        body.Trim().ShouldBe("203.0.113.25");
    }

    [Test]
    public async Task MyIpShortPathShouldReturnPlainTextAddress()
    {
        var body = await TestApp.GetHttpStringAsync("/myIp");
        body.Trim().ShouldBe("203.0.113.25");
    }

    [Test]
    public async Task LegacyApiPathShouldRewriteToV1()
    {
        var body = await TestApp.GetHttpStringAsync("/api/IpLookup/GetMyIpPlain");
        body.Trim().ShouldBe("203.0.113.25");
    }
}
