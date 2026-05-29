using Ntk.Note.IP.Application.Blacklist.Queries.GetListBlacklist;

namespace Ntk.Note.IP.Application.FunctionalTests.Blacklist;

public class BlacklistTests : TestBase
{
    [Test]
    public async Task ShouldGetListBlacklistHits()
    {
        var hits = await TestApp.SendAsync(new GetListBlacklistQuery("203.0.113.50"));
        hits.ShouldNotBeEmpty();
        hits.ShouldContain(h => h.ListId == "zen.spamhaus.org" && h.IsListed);
    }
}
