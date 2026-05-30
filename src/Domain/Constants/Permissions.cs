namespace Ntk.Note.IP.Domain.Constants;

public static class Permissions
{
    public const string AdminDashboardView = "admin.dashboard.view";
    public const string AdminUsersView = "admin.users.view";
    public const string AdminUsersManage = "admin.users.manage";
    public const string AdminRolesView = "admin.roles.view";
    public const string AdminRolesManage = "admin.roles.manage";
    public const string AdminIpNotesView = "admin.ipnotes.view";
    public const string AdminIpNotesManage = "admin.ipnotes.manage";
    public const string AdminIpLookupsView = "admin.iplookups.view";
    public const string AdminIpLookupsManage = "admin.iplookups.manage";
    public const string AdminPushView = "admin.push.view";
    public const string AdminPushManage = "admin.push.manage";
    public const string AdminOutboxView = "admin.outbox.view";

    public static readonly IReadOnlyList<string> All =
    [
        AdminDashboardView,
        AdminUsersView,
        AdminUsersManage,
        AdminRolesView,
        AdminRolesManage,
        AdminIpNotesView,
        AdminIpNotesManage,
        AdminIpLookupsView,
        AdminIpLookupsManage,
        AdminPushView,
        AdminPushManage,
        AdminOutboxView,
    ];
}
