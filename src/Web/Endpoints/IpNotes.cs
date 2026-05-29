using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Application.IpNotes.Commands.AddIpNote;
using Ntk.Note.IP.Application.IpNotes.Commands.DeleteIpNote;
using Ntk.Note.IP.Application.IpNotes.Commands.UpdateIpNote;
using Ntk.Note.IP.Application.IpNotes.Queries.GetListIpNotes;
using Ntk.Note.IP.Application.IpNotes.Queries.GetOneIpNote;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class IpNotes : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireAuthorization();

        groupBuilder.MapGet(GetListIpNotes);
        groupBuilder.MapGet(GetOneIpNote, "{id}");
        groupBuilder.MapPost(AddIpNote);
        groupBuilder.MapPut(UpdateIpNote, "{id}");
        groupBuilder.MapDelete(DeleteIpNote, "{id}");
    }

    [EndpointSummary("GetList IP notes")]
    [EndpointDescription("Returns all IP notes for the authenticated user as a homogeneous list in data.")]
    public static async Task<Ok<ErrorExceptionResult<List<IpNoteDto>>>> GetListIpNotes(ISender sender)
    {
        var data = await sender.Send(new GetListIpNotesQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetOne IP note")]
    [EndpointDescription("Returns a single IP note by id.")]
    public static async Task<Ok<ErrorExceptionResult<IpNoteDto>>> GetOneIpNote(ISender sender, int id)
    {
        var data = await sender.Send(new GetOneIpNoteQuery(id));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("Add IP note")]
    [EndpointDescription("Creates a new IP note.")]
    public static async Task<Created<ErrorExceptionResult<int>>> AddIpNote(ISender sender, AddIpNoteCommand command)
    {
        var id = await sender.Send(command);
        return ApiEnvelopeResults.Created($"/api/{nameof(IpNotes)}/{id}", id);
    }

    [EndpointSummary("Update IP note")]
    [EndpointDescription("Updates an existing IP note.")]
    public static async Task<Results<NoContent, BadRequest<ErrorExceptionResult>>> UpdateIpNote(
        ISender sender,
        int id,
        UpdateIpNoteCommand command)
    {
        if (id != command.Id)
        {
            return TypedResults.BadRequest(
                ErrorExceptionResult.Fail(ErrorCodes.Validation, "Route id does not match body id."));
        }

        await sender.Send(command);
        return TypedResults.NoContent();
    }

    [EndpointSummary("Delete IP note")]
    [EndpointDescription("Deletes an IP note by id.")]
    public static async Task<NoContent> DeleteIpNote(ISender sender, int id)
    {
        await sender.Send(new DeleteIpNoteCommand(id));
        return TypedResults.NoContent();
    }
}
