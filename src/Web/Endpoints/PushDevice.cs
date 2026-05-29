using Microsoft.AspNetCore.Http.HttpResults;
using Ntk.Note.IP.Application.PushDevice.Commands.ActionRegisterPushDevice;
using Ntk.Note.IP.Application.PushDevice.Commands.ActionUnregisterPushDevice;
using Ntk.Note.IP.Web.Infrastructure;

namespace Ntk.Note.IP.Web.Endpoints;

public class PushDevice : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization();

        groupBuilder.MapPost(ActionRegister, "ActionRegister");
        groupBuilder.MapPost(ActionUnregister, "ActionUnregister");
    }

    [EndpointSummary("ActionRegister push device")]
    [EndpointDescription("Registers or updates an FCM/APNs device token for the authenticated user.")]
    public static async Task<NoContent> ActionRegister(ISender sender, ActionRegisterPushDeviceCommand command)
    {
        await sender.Send(command);
        return TypedResults.NoContent();
    }

    [EndpointSummary("ActionUnregister push device")]
    [EndpointDescription("Removes a device token for the authenticated user (e.g. on logout).")]
    public static async Task<NoContent> ActionUnregister(ISender sender, ActionUnregisterPushDeviceCommand command)
    {
        await sender.Send(command);
        return TypedResults.NoContent();
    }
}
