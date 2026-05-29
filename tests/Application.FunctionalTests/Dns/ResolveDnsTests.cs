using Ntk.Note.IP.Application.Common.Exceptions;
using Ntk.Note.IP.Application.Dns.Queries.ResolveDns;

namespace Ntk.Note.IP.Application.FunctionalTests.Dns;

public class ResolveDnsTests : TestBase
{
    [Test]
    public async Task ShouldResolveDnsRecordsForDomain()
    {
        var result = await TestApp.SendAsync(new ResolveDnsQuery { Domain = "example.com" });
        result.Domain.ShouldBe("example.com");
        result.Records.ShouldContain(r => r.Type == "A");
        result.Records.ShouldContain(r => r.Type == "MX");
    }

    [Test]
    public async Task ShouldRejectInvalidDomain()
    {
        await Should.ThrowAsync<ValidationException>(() =>
            TestApp.SendAsync(new ResolveDnsQuery { Domain = "not a domain!!!" }));
    }
}
