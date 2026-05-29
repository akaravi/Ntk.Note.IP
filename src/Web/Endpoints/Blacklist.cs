using Ntk.Note.IP.Application.Blacklist;
using Ntk.Note.IP.Application.Blacklist.Queries.GetListBlacklist;
using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class Blacklist : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.GuestApi);

        groupBuilder.MapGet(GetListBlacklist, "GetList").AllowAnonymous();
    }

    [EndpointSummary("GetList blacklist checks")]
    [EndpointDescription("Checks the IP against multiple DNSBL lists; data is a homogeneous array of hits.")]
    public static async Task<Ok<ErrorExceptionResult<List<BlacklistHitDto>>>> GetListBlacklist(ISender sender, string address)
    {
        var data = await sender.Send(new GetListBlacklistQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }
}
