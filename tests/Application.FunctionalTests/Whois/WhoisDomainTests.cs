using Ntk.Note.IP.Application.Whois.Queries.GetWhoisDomain;

namespace Ntk.Note.IP.Application.FunctionalTests.Whois;

public class WhoisDomainTests : TestBase
{
    [Test]
    public async Task ShouldGetWhoisForDomain()
    {
        var whois = await TestApp.SendAsync(new GetWhoisDomainQuery("example.com"));
        whois.Domain.ShouldBe("example.com");
        whois.NameServers.ShouldNotBeEmpty();
    }
}
