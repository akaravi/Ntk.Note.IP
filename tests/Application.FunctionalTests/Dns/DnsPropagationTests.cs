using Ntk.Note.IP.Application.Dns.Queries.GetListDnsPropagation;

namespace Ntk.Note.IP.Application.FunctionalTests.Dns;

public class DnsPropagationTests : TestBase
{
    [Test]
    public async Task ShouldCompareDnsPropagationAcrossResolvers()
    {
        var result = await TestApp.SendAsync(new GetListDnsPropagationQuery
        {
            Domain = "example.com",
            Type = "A"
        });

        result.Domain.ShouldBe("example.com");
        result.Resolvers.Count.ShouldBeGreaterThanOrEqualTo(3);
        result.Resolvers.ShouldContain(r => !r.MatchesReference);
    }
}
