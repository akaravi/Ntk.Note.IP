using Ntk.Note.IP.Application.IpTools.Queries.ActionCheckPort;
using Ntk.Note.IP.Application.IpTools.Queries.GetSslCertificateInfo;

namespace Ntk.Note.IP.Application.FunctionalTests.IpTools;

public class PortAndSslTests : TestBase
{
    [Test]
    public async Task ShouldCheckOpenPort()
    {
        var result = await TestApp.SendAsync(new ActionCheckPortQuery("example.com", 443));
        result.IsOpen.ShouldBeTrue();
        result.Port.ShouldBe(443);
    }

    [Test]
    public async Task ShouldGetSslCertificateInfo()
    {
        var cert = await TestApp.SendAsync(new GetSslCertificateInfoQuery("example.com"));
        cert.Host.ShouldBe("example.com");
        cert.IsValidNow.ShouldBeTrue();
        cert.Subject.ShouldNotBeNull();
        cert.Subject.ShouldContain("example.com");
    }
}
