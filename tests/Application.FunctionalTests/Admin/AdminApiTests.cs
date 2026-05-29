using Ntk.Note.IP.Application.Admin.Queries.GetListAdminUsers;
using Ntk.Note.IP.Application.Admin.Queries.GetOneAdminAccess;
using Ntk.Note.IP.Application.Admin.Queries.GetOneAdminDashboard;
using Ntk.Note.IP.Application.Common.Exceptions;
using Ntk.Note.IP.Application.FunctionalTests.Infrastructure;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.FunctionalTests.Admin;

public class AdminApiTests : TestBase
{
    [Test]
    public async Task NonAdministratorShouldBeForbiddenFromAdminDashboard()
    {
        await TestApp.RunAsDefaultUserAsync();

        await Should.ThrowAsync<ForbiddenAccessException>(() =>
            TestApp.SendAsync(new GetOneAdminDashboardQuery()));
    }

    [Test]
    public async Task AdministratorShouldGetDashboardStats()
    {
        await TestApp.RunAsAdministratorAsync();

        var result = await TestApp.SendAsync(new GetOneAdminDashboardQuery());

        result.UserCount.ShouldBeGreaterThan(0);
    }

    [Test]
    public async Task AdministratorAccessQueryShouldReturnTrueForAdmin()
    {
        await TestApp.RunAsAdministratorAsync();

        var result = await TestApp.SendAsync(new GetOneAdminAccessQuery());

        result.IsAdministrator.ShouldBeTrue();
        result.Roles.ShouldContain(Domain.Constants.Roles.Administrator);
    }

    [Test]
    public async Task DefaultUserAccessQueryShouldReturnFalse()
    {
        await TestApp.RunAsDefaultUserAsync();

        var result = await TestApp.SendAsync(new GetOneAdminAccessQuery());

        result.IsAdministrator.ShouldBeFalse();
    }

    [Test]
    public async Task NonAdministratorShouldNotListAllUsers()
    {
        await TestApp.RunAsDefaultUserAsync();

        await Should.ThrowAsync<ForbiddenAccessException>(() =>
            TestApp.SendAsync(new GetListAdminUsersQuery()));
    }
}
