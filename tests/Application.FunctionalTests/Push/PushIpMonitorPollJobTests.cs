using Microsoft.Extensions.DependencyInjection;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using Ntk.Note.IP.Application.IpLookup.Commands.ActionMonitorMyIp;
using Ntk.Note.IP.Application.PushDevice.Commands.ActionRegisterPushDevice;
using Ntk.Note.IP.Infrastructure.BackgroundJobs;

namespace Ntk.Note.IP.Application.FunctionalTests.Push;

public class PushIpMonitorPollJobTests : TestBase
{
    [TearDown]
    public void TearDown() => WebApiFactory.PushSender.Sent.Clear();

    [Test]
    public async Task ShouldSendDataPollWhenSnapshotIsStale()
    {
        await TestApp.RunAsDefaultUserAsync();

        await TestApp.SendAsync(new ActionRegisterPushDeviceCommand
        {
            DeviceToken = "fcm-poll-test",
            Platform = "android",
        });

        await TestApp.SendAsync(new ActionMonitorMyIpCommand());

        using (var scope = FunctionalTestSetup.ScopeFactory.CreateScope())
        {
            var context = scope.ServiceProvider.GetRequiredService<IApplicationDbContext>();
            var snapshot = context.UserPublicIpSnapshots.Single();
            snapshot.UpdatedAt = DateTimeOffset.UtcNow.AddHours(-3);
            await context.SaveChangesAsync(CancellationToken.None);
        }

        WebApiFactory.PushSender.Sent.Clear();

        using (var scope = FunctionalTestSetup.ScopeFactory.CreateScope())
        {
            var job = scope.ServiceProvider.GetRequiredService<PushIpMonitorPollJob>();
            await job.ExecuteAsync();
        }

        WebApiFactory.PushSender.Sent.Count.ShouldBe(1);
        WebApiFactory.PushSender.Sent[0].DeviceToken.ShouldBe("fcm-poll-test");
        WebApiFactory.PushSender.Sent[0].Data!["type"].ShouldBe(PushIpMonitorPollService.MonitorIpDataType);
    }

    [Test]
    public async Task ShouldSkipPollWhenSnapshotIsFresh()
    {
        await TestApp.RunAsDefaultUserAsync();

        await TestApp.SendAsync(new ActionRegisterPushDeviceCommand
        {
            DeviceToken = "fcm-poll-fresh",
            Platform = "android",
        });

        await TestApp.SendAsync(new ActionMonitorMyIpCommand());

        WebApiFactory.PushSender.Sent.Clear();

        using var scope = FunctionalTestSetup.ScopeFactory.CreateScope();
        var job = scope.ServiceProvider.GetRequiredService<PushIpMonitorPollJob>();
        await job.ExecuteAsync();

        WebApiFactory.PushSender.Sent.Count.ShouldBe(0);
    }
}
