using Ntk.Note.IP.Application.IpTools.Queries.ActionCalculateSubnet;
using Ntk.Note.IP.Application.IpTools.Queries.ActionConvertIp;
using Ntk.Note.IP.Application.IpTools.Queries.GetPrivacyFlags;

namespace Ntk.Note.IP.Application.FunctionalTests.IpTools;

public class IpToolsTests : TestBase
{
    [Test]
    public async Task ShouldGetPrivacyFlags()
    {
        var flags = await TestApp.SendAsync(new GetPrivacyFlagsQuery("8.8.8.8"));
        flags.Address.ShouldBe("8.8.8.8");
        flags.Mobile.ShouldBeTrue();
    }

    [Test]
    public async Task ShouldConvertIpFromUInt32()
    {
        var result = await TestApp.SendAsync(new ActionConvertIpQuery { UInt32 = 134744072 });
        result.Address.ShouldBe("8.8.8.8");
        result.Hex.ShouldBe("0x08080808");
    }

    [Test]
    public async Task ShouldCalculateSubnet()
    {
        var subnet = await TestApp.SendAsync(new ActionCalculateSubnetQuery("10.0.0.0/8"));
        subnet.PrefixLength.ShouldBe(8);
        subnet.UsableHosts.ShouldBeGreaterThan(0);
    }
}
