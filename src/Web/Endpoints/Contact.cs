using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.Contact;
using Ntk.Note.IP.Application.Contact.Commands.AddContactSubmission;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.RateLimiting;

namespace Ntk.Note.IP.Web.Endpoints;

public class Contact : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.AuthSensitive);

        groupBuilder.MapPost(AddContactSubmission);
    }

    [EndpointSummary("Add contact submission")]
    [EndpointDescription("Stores a support ticket and emails the configured site contact address.")]
    public static async Task<Created<ErrorExceptionResult<ContactSubmissionResultDto>>> AddContactSubmission(
        ISender sender,
        AddContactSubmissionCommand command)
    {
        var result = await sender.Send(command);
        return ApiEnvelopeResults.Created($"/api/{nameof(Contact)}/{result.TicketId}", result);
    }
}
