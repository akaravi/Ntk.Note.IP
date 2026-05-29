using Ntk.Note.IP.Application.Whois.Queries.GetWhoisIp;

namespace Ntk.Note.IP.Application.FunctionalTests.Whois;

public class WhoisTests : TestBase
{
    [Test]
    public async Task ShouldGetWhoisForIp()
    {
        var whois = await TestApp.SendAsync(new GetWhoisIpQuery("8.8.8.8"));
        whois.Address.ShouldBe("8.8.8.8");
        whois.Handle.ShouldNotBeNullOrWhiteSpace();
    }
}
