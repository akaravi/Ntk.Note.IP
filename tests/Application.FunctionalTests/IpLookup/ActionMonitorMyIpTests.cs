using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using Ntk.Note.IP.Application.IpLookup.Commands.ActionMonitorMyIp;
using Ntk.Note.IP.Application.PushDevice.Commands.ActionRegisterPushDevice;

namespace Ntk.Note.IP.Application.FunctionalTests.IpLookup;

public class ActionMonitorMyIpTests : TestBase
{
    [TearDown]
    public void TearDown()
    {
        WebApiFactory.ClientIpResolver.SetAddress("203.0.113.25");
        WebApiFactory.PushSender.Sent.Clear();
    }

    [Test]
    public async Task ShouldNotifyWhenPublicIpChanges()
    {
        await TestApp.RunAsDefaultUserAsync();
        WebApiFactory.PushSender.Sent.Clear();
        WebApiFactory.ClientIpResolver.SetAddress("203.0.113.30");

        await TestApp.SendAsync(new ActionRegisterPushDeviceCommand
        {
            DeviceToken = "fcm-monitor-test",
            Platform = "android",
        });

        var first = await TestApp.SendAsync(new ActionMonitorMyIpCommand());
        first.IpChanged.ShouldBeFalse();
        WebApiFactory.PushSender.Sent.Count.ShouldBe(0);

        WebApiFactory.ClientIpResolver.SetAddress("203.0.113.31");

        var second = await TestApp.SendAsync(new ActionMonitorMyIpCommand());
        second.IpChanged.ShouldBeTrue();
        second.PreviousAddress.ShouldBe("203.0.113.30");
        WebApiFactory.PushSender.Sent.Count.ShouldBe(1);
        WebApiFactory.PushSender.Sent[0].DeviceToken.ShouldBe("fcm-monitor-test");
    }
}
