using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Application.IpNotes.Commands.AddIpNote;
using Ntk.Note.IP.Application.IpNotes.Commands.DeleteIpNote;
using Ntk.Note.IP.Application.IpNotes.Queries.GetListIpNotes;
using Ntk.Note.IP.Application.IpNotes.Queries.GetOneIpNote;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Infrastructure.Data;

namespace Ntk.Note.IP.Application.FunctionalTests.IpNotes;

public class IpNoteTests : TestBase
{
    [Test]
    public async Task ShouldCreateAndRetrieveIpNote()
    {
        await TestApp.RunAsDefaultUserAsync();

        var id = await TestApp.SendAsync(new AddIpNoteCommand
        {
            Address = "203.0.113.10",
            Title = "Test note",
            Body = "IPNote functional test",
            Tags = "test,ipnote"
        });

        var one = await TestApp.SendAsync(new GetOneIpNoteQuery(id));
        one.Address.ShouldBe("203.0.113.10");
        one.Title.ShouldBe("Test note");

        var list = await TestApp.SendAsync(new GetListIpNotesQuery());
        list.ShouldContain(n => n.Id == id);
    }

    [Test]
    public async Task ShouldDeleteIpNote()
    {
        await TestApp.RunAsDefaultUserAsync();

        var id = await TestApp.SendAsync(new AddIpNoteCommand
        {
            Address = "198.51.100.1",
            Title = "Delete me"
        });

        await TestApp.SendAsync(new DeleteIpNoteCommand(id));

        await Should.ThrowAsync<NotFoundException>(() => TestApp.SendAsync(new GetOneIpNoteQuery(id)));
    }

    [Test]
    public async Task ShouldPersistSnapshotMetadataOnAdd()
    {
        await TestApp.RunAsDefaultUserAsync();

        var notedAt = DateTimeOffset.Parse("2026-05-29T12:00:00+03:30");

        var id = await TestApp.SendAsync(new AddIpNoteCommand
        {
            Address = "203.0.113.20",
            Title = "Snapshot note",
            NotedAtClient = notedAt,
            ClientTimezone = "Asia/Tehran",
            LocalIpAddress = "192.168.1.10",
            DeviceInfo = new IpNoteDeviceInfoDto
            {
                Browser = "Chrome",
                Os = "Windows",
                DeviceType = "Desktop",
                Language = "fa-IR",
                Label = "Chrome · Windows"
            },
            IpSnapshot = new IpDetailsDto
            {
                Address = "203.0.113.20",
                Isp = "Example ISP",
                Geo = new GeoLocationDto { City = "Tehran", CountryCode = "IR", Region = "Tehran" },
                Asn = new AsnInfoDto { Number = "6453", Organization = "Example ASN" }
            }
        });

        var one = await TestApp.SendAsync(new GetOneIpNoteQuery(id));
        one.NotedAtClient.ShouldBe(notedAt);
        one.ClientTimezone.ShouldBe("Asia/Tehran");
        one.LocalIpAddress.ShouldBe("192.168.1.10");
        one.City.ShouldBe("Tehran");
        one.CountryCode.ShouldBe("IR");
        one.Isp.ShouldBe("Example ISP");
        one.DeviceLabel.ShouldBe("Chrome · Windows");
        one.DeviceInfo.ShouldNotBeNull();
        one.DeviceInfo!.Browser.ShouldBe("Chrome");
        one.IpSnapshot.ShouldNotBeNull();
        one.IpSnapshot!.Geo.City.ShouldBe("Tehran");
    }

    [Test]
    public async Task ShouldSoftDeleteWithoutPhysicalRemove()
    {
        await TestApp.RunAsDefaultUserAsync();

        var id = await TestApp.SendAsync(new AddIpNoteCommand
        {
            Address = "203.0.113.99",
            Title = "Soft delete"
        });

        await TestApp.SendAsync(new DeleteIpNoteCommand(id));

        using var scope = FunctionalTestSetup.ScopeFactory.CreateScope();
        var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
        var row = await context.IpNotes.IgnoreQueryFilters().FirstAsync(n => n.Id == id);
        row.IsSoftDeleted.ShouldBeTrue();
    }

    [Test]
    public async Task ShouldNotAccessAnotherUsersNote()
    {
        await TestApp.RunAsUserAsync("owner@local", "Testing1234!", []);

        var id = await TestApp.SendAsync(new AddIpNoteCommand
        {
            Address = "203.0.113.50",
            Title = "Private"
        });

        await TestApp.RunAsUserAsync("other@local", "Testing1234!", []);

        await Should.ThrowAsync<NotFoundException>(() => TestApp.SendAsync(new GetOneIpNoteQuery(id)));
        await Should.ThrowAsync<NotFoundException>(() => TestApp.SendAsync(new DeleteIpNoteCommand(id)));
    }
}
