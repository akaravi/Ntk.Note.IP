using Ntk.Note.IP.Application.Admin;
using Ntk.Note.IP.Application.Admin.Commands.ActionAddAdminRole;
using Ntk.Note.IP.Application.Admin.Commands.ActionAdminDeleteIpLookupRecord;
using Ntk.Note.IP.Application.Admin.Commands.ActionAdminDeleteIpNote;
using Ntk.Note.IP.Application.Admin.Commands.ActionAdminDeletePushDevice;
using Ntk.Note.IP.Application.Admin.Commands.ActionDeleteAdminRole;
using Ntk.Note.IP.Application.Admin.Commands.ActionSetAdminUserRoles;
using Ntk.Note.IP.Application.Admin.Commands.ActionUpdateAdminRolePermissions;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminIpLookupRecords;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminIpNotes;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminOutboxMessages;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminPermissions;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminPushDevices;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminRoles;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminUsers;
using Ntk.Note.IP.Application.Admin.Queries.GetOneAdminAccess;
using Ntk.Note.IP.Application.Admin.Queries.GetOneAdminDashboard;
using Ntk.Note.IP.Application.Admin.Commands.ActionUpdateSupportTicketStatus;
using Ntk.Note.IP.Application.Admin.Queries.GetListAdminSupportTickets;
using Ntk.Note.IP.Domain.Enums;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Domain.Constants;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class AdminDashboard : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetOneAdminDashboard, "GetOne");
    }

    [EndpointSummary("GetOne admin dashboard")]
    [EndpointDescription("Returns aggregate counts for the admin dashboard.")]
    public static async Task<Ok<ErrorExceptionResult<AdminDashboardDto>>> GetOneAdminDashboard(ISender sender)
    {
        var data = await sender.Send(new GetOneAdminDashboardQuery());
        return ApiEnvelopeResults.Ok(data);
    }
}

public class AdminAccess : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization();

        groupBuilder.MapGet(GetOneAdminAccess, "GetOne");
    }

    [EndpointSummary("GetOne admin access")]
    [EndpointDescription("Returns whether the authenticated caller has administrator access.")]
    public static async Task<Ok<ErrorExceptionResult<AdminAccessDto>>> GetOneAdminAccess(ISender sender)
    {
        var data = await sender.Send(new GetOneAdminAccessQuery());
        return ApiEnvelopeResults.Ok(data);
    }
}

public class AdminUsers : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminUsers, "GetList");
        groupBuilder.MapPost(ActionSetAdminUserRoles, "ActionSetRoles");
    }

    [EndpointSummary("GetList admin users")]
    [EndpointDescription("Returns all registered users with roles.")]
    public static async Task<Ok<ErrorExceptionResult<IReadOnlyList<AdminUserDto>>>> GetListAdminUsers(ISender sender)
    {
        var data = await sender.Send(new GetListAdminUsersQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionSet admin user roles")]
    [EndpointDescription("Replaces role membership for a user.")]
    public static async Task<NoContent> ActionSetAdminUserRoles(ISender sender, ActionSetAdminUserRolesCommand command)
    {
        await sender.Send(command);
        return TypedResults.NoContent();
    }
}

public class AdminRoles : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminRoles, "GetList");
        groupBuilder.MapGet(GetListAdminPermissions, "GetListPermissions");
        groupBuilder.MapPost(ActionAddAdminRole, "Add");
        groupBuilder.MapPost(ActionUpdateAdminRolePermissions, "UpdatePermissions");
        groupBuilder.MapDelete(ActionDeleteAdminRole, "{roleId}");
    }

    [EndpointSummary("GetList admin roles")]
    [EndpointDescription("Returns identity roles with permission claims and member counts.")]
    public static async Task<Ok<ErrorExceptionResult<IReadOnlyList<AdminRoleDto>>>> GetListAdminRoles(ISender sender)
    {
        var data = await sender.Send(new GetListAdminRolesQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetList admin permission catalog")]
    [EndpointDescription("Returns all configurable admin permissions.")]
    public static async Task<Ok<ErrorExceptionResult<IReadOnlyList<AdminPermissionCatalogItemDto>>>> GetListAdminPermissions(
        ISender sender)
    {
        var data = await sender.Send(new GetListAdminPermissionsQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("Add admin role")]
    [EndpointDescription("Creates a role with permission claims.")]
    public static async Task<NoContent> ActionAddAdminRole(ISender sender, ActionAddAdminRoleCommand command)
    {
        await sender.Send(command);
        return TypedResults.NoContent();
    }

    [EndpointSummary("Update admin role permissions")]
    [EndpointDescription("Replaces permission claims for a role.")]
    public static async Task<NoContent> ActionUpdateAdminRolePermissions(
        ISender sender,
        ActionUpdateAdminRolePermissionsCommand command)
    {
        await sender.Send(command);
        return TypedResults.NoContent();
    }

    [EndpointSummary("ActionDelete admin role")]
    [EndpointDescription("Deletes a non-system role with no members.")]
    public static async Task<NoContent> ActionDeleteAdminRole(ISender sender, string roleId)
    {
        await sender.Send(new ActionDeleteAdminRoleCommand(roleId));
        return TypedResults.NoContent();
    }
}

public class AdminIpNotes : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminIpNotes, "GetList");
        groupBuilder.MapDelete(ActionAdminDeleteIpNote, "{id}");
    }

    [EndpointSummary("GetList admin IP notes")]
    [EndpointDescription("Returns all IP notes across users.")]
    public static async Task<Ok<ErrorExceptionResult<List<AdminIpNoteListItemDto>>>> GetListAdminIpNotes(
        ISender sender,
        string? search)
    {
        var data = await sender.Send(new GetListAdminIpNotesQuery(search));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionDelete admin IP note")]
    [EndpointDescription("Permanently deletes an IP note.")]
    public static async Task<NoContent> ActionAdminDeleteIpNote(ISender sender, int id)
    {
        await sender.Send(new ActionAdminDeleteIpNoteCommand(id));
        return TypedResults.NoContent();
    }
}

public class AdminIpLookupRecords : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminIpLookupRecords, "GetList");
        groupBuilder.MapDelete(ActionAdminDeleteIpLookupRecord, "{id}");
    }

    [EndpointSummary("GetList admin IP lookup records")]
    [EndpointDescription("Returns cached IP lookup records.")]
    public static async Task<Ok<ErrorExceptionResult<List<IpLookupRecordDto>>>> GetListAdminIpLookupRecords(
        ISender sender,
        string? search)
    {
        var data = await sender.Send(new GetListAdminIpLookupRecordsQuery(search));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionDelete admin IP lookup record")]
    [EndpointDescription("Deletes a cached lookup record.")]
    public static async Task<NoContent> ActionAdminDeleteIpLookupRecord(ISender sender, int id)
    {
        await sender.Send(new ActionAdminDeleteIpLookupRecordCommand(id));
        return TypedResults.NoContent();
    }
}

public class AdminPushDevices : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminPushDevices, "GetList");
        groupBuilder.MapDelete(ActionAdminDeletePushDevice, "{id}");
    }

    [EndpointSummary("GetList admin push devices")]
    [EndpointDescription("Returns registered push notification devices.")]
    public static async Task<Ok<ErrorExceptionResult<List<AdminPushDeviceDto>>>> GetListAdminPushDevices(ISender sender)
    {
        var data = await sender.Send(new GetListAdminPushDevicesQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionDelete admin push device")]
    [EndpointDescription("Removes a push device registration.")]
    public static async Task<NoContent> ActionAdminDeletePushDevice(ISender sender, int id)
    {
        await sender.Send(new ActionAdminDeletePushDeviceCommand(id));
        return TypedResults.NoContent();
    }
}

public class AdminOutbox : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminOutboxMessages, "GetList");
    }

    [EndpointSummary("GetList admin outbox messages")]
    [EndpointDescription("Returns outbox messages for background dispatch monitoring.")]
    public static async Task<Ok<ErrorExceptionResult<List<AdminOutboxMessageDto>>>> GetListAdminOutboxMessages(
        ISender sender,
        bool pendingOnly = false)
    {
        var data = await sender.Send(new GetListAdminOutboxMessagesQuery(pendingOnly));
        return ApiEnvelopeResults.Ok(data);
    }
}

public class AdminSupportTickets : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization(Policies.RequireAdministrator);

        groupBuilder.MapGet(GetListAdminSupportTickets, "GetList");
        groupBuilder.MapPost(ActionUpdateSupportTicketStatus, "ActionUpdateStatus");
    }

    [EndpointSummary("GetList admin support tickets")]
    [EndpointDescription("Returns contact form tickets for the admin ticketing panel.")]
    public static async Task<Ok<ErrorExceptionResult<IReadOnlyList<AdminSupportTicketDto>>>> GetListAdminSupportTickets(
        ISender sender,
        bool openOnly = false)
    {
        var data = await sender.Send(new GetListAdminSupportTicketsQuery(openOnly));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionUpdate support ticket status")]
    [EndpointDescription("Updates ticket status (Open or Closed).")]
    public static async Task<NoContent> ActionUpdateSupportTicketStatus(
        ISender sender,
        ActionUpdateSupportTicketStatusRequest request)
    {
        await sender.Send(new ActionUpdateSupportTicketStatusCommand(request.Id, request.Status));
        return TypedResults.NoContent();
    }
}

public sealed class ActionUpdateSupportTicketStatusRequest
{
    public int Id { get; init; }

    public SupportTicketStatus Status { get; init; }
}
