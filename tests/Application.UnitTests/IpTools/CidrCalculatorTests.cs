using Ntk.Note.IP.Application.IpTools;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.IpTools;

public class CidrCalculatorTests
{
    [Test]
    public void ShouldCalculateSlash24()
    {
        var subnet = CidrCalculator.Calculate("192.168.1.10/24");
        subnet.NetworkAddress.ShouldBe("192.168.1.0");
        subnet.BroadcastAddress.ShouldBe("192.168.1.255");
        subnet.UsableHosts.ShouldBe(254);
    }
}
