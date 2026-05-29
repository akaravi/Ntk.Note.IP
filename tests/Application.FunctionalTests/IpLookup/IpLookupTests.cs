using Ntk.Note.IP.Application.Common.Exceptions;
using Ntk.Note.IP.Application.IpLookup.Commands.ActionLookupIp;
using Ntk.Note.IP.Application.IpLookup.Queries.GetAsnInfo;
using Ntk.Note.IP.Application.IpLookup.Queries.GetGeoLocation;
using Ntk.Note.IP.Application.IpLookup.Queries.GetIpDetails;
using Ntk.Note.IP.Application.IpLookup.Queries.GetReverseDns;
using Ntk.Note.IP.Application.IpLookup.Queries.GetListIpLookupRecords;
using Ntk.Note.IP.Application.IpLookup.Queries.GetMyIp;
using Ntk.Note.IP.Application.IpLookup.Queries.GetOneIpLookupRecord;
using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Application.FunctionalTests.IpLookup;

public class IpLookupTests : TestBase
{
    [Test]
    public async Task ShouldResolveMyIpFromClientResolver()
    {
        var myIp = await TestApp.SendAsync(new GetMyIpQuery());
        myIp.Address.ShouldBe("203.0.113.25");
        myIp.IsIPv6.ShouldBeFalse();
    }

    [Test]
    public async Task ShouldActionLookupAndPersistRecord()
    {
        var record = await TestApp.SendAsync(new ActionLookupIpCommand { Address = "8.8.8.8" });
        record.Address.ShouldBe("8.8.8.8");
        record.CountryCode.ShouldBe("IR");
        record.City.ShouldBe("Tehran");

        await TestApp.RunAsDefaultUserAsync();

        var list = await TestApp.SendAsync(new GetListIpLookupRecordsQuery());
        list.ShouldContain(r => r.Id == record.Id);

        var one = await TestApp.SendAsync(new GetOneIpLookupRecordQuery(record.Id));
        one.Asn.ShouldBe(record.Asn);
    }

    [Test]
    public async Task ShouldGetIpDetailsWithGeoAsnAndReverseDns()
    {
        var details = await TestApp.SendAsync(new GetIpDetailsQuery("8.8.8.8"));
        details.Address.ShouldBe("8.8.8.8");
        details.Geo.City.ShouldBe("Tehran");
        details.Asn.Number.ShouldBe("44244");
        details.ReverseDns.ShouldBe("test.example.local");
    }

    [Test]
    public async Task ShouldGetGeoLocationAndAsnSeparately()
    {
        var geo = await TestApp.SendAsync(new GetGeoLocationQuery("1.1.1.1"));
        geo.CountryCode.ShouldBe("IR");

        var asn = await TestApp.SendAsync(new GetAsnInfoQuery("1.1.1.1"));
        asn.Organization.ShouldNotBeNull();
        asn.Organization.ShouldContain("Iran");
    }

    [Test]
    public async Task ShouldGetReverseDns()
    {
        var ptr = await TestApp.SendAsync(new GetReverseDnsQuery("8.8.4.4"));
        ptr.HostName.ShouldBe("test.example.local");
    }

    [Test]
    public async Task ShouldRejectInvalidIpOnActionLookup()
    {
        await Should.ThrowAsync<ValidationException>(() =>
            TestApp.SendAsync(new ActionLookupIpCommand { Address = "not-an-ip" }));
    }

    [Test]
    public async Task ShouldClassifySpecialScopesInIpDetails()
    {
        var cgnat = await TestApp.SendAsync(new GetIpDetailsQuery("100.64.0.1"));
        cgnat.Scope.ShouldBe(IpAddressScope.Cgnat);

        var linkLocal = await TestApp.SendAsync(new GetIpDetailsQuery("169.254.88.1"));
        linkLocal.Scope.ShouldBe(IpAddressScope.LinkLocal);

        var privateIp = await TestApp.SendAsync(new GetIpDetailsQuery("10.255.0.1"));
        privateIp.Scope.ShouldBe(IpAddressScope.Private);
    }
}
