using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using Ntk.Note.IP.Application.IpNotes.Commands.AddIpNote;
using Ntk.Note.IP.Application.IpNotes.Commands.UpdateIpNote;
using Ntk.Note.IP.Application.IpNotes.Queries.GetOneIpNote;
using Ntk.Note.IP.Application.PushDevice.Commands.ActionRegisterPushDevice;
using Ntk.Note.IP.Application.PushDevice.Commands.ActionUnregisterPushDevice;
using Ntk.Note.IP.Infrastructure.Data;

namespace Ntk.Note.IP.Application.FunctionalTests.PushDevice;

public class PushDeviceTests : TestBase
{
    [Test]
    public async Task ShouldRegisterAndUnregisterDeviceToken()
    {
        await TestApp.RunAsDefaultUserAsync();

        await TestApp.SendAsync(new ActionRegisterPushDeviceCommand
        {
            DeviceToken = "fcm-token-test-1",
            Platform = "android",
        });

        using (var scope = FunctionalTestSetup.ScopeFactory.CreateScope())
        {
            var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var row = await context.PushDeviceRegistrations
                .FirstAsync(p => p.DeviceToken == "fcm-token-test-1");
            row.Platform.ShouldBe("android");
        }

        await TestApp.SendAsync(new ActionUnregisterPushDeviceCommand
        {
            DeviceToken = "fcm-token-test-1",
        });

        using (var scope = FunctionalTestSetup.ScopeFactory.CreateScope())
        {
            var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
            var count = await context.PushDeviceRegistrations
                .CountAsync(p => p.DeviceToken == "fcm-token-test-1");
            count.ShouldBe(0);
        }
    }
}

public class IpNoteUpdateTests : TestBase
{
    [Test]
    public async Task ShouldUpdateIpNote()
    {
        await TestApp.RunAsDefaultUserAsync();

        var id = await TestApp.SendAsync(new AddIpNoteCommand
        {
            Address = "203.0.113.20",
            Title = "Before",
        });

        await TestApp.SendAsync(new UpdateIpNoteCommand
        {
            Id = id,
            Address = "203.0.113.21",
            Title = "After",
            Body = "Updated body",
            Tags = "updated",
        });

        var one = await TestApp.SendAsync(new GetOneIpNoteQuery(id));
        one.Address.ShouldBe("203.0.113.21");
        one.Title.ShouldBe("After");
        one.Body.ShouldBe("Updated body");
    }
}
