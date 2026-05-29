using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.Whois;
using Ntk.Note.IP.Application.Whois.Queries.GetWhoisDomain;
using Ntk.Note.IP.Application.Whois.Queries.GetWhoisIp;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class Whois : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.GuestApi);

        groupBuilder.MapGet(GetWhoisIp, "GetWhoisIp").AllowAnonymous();
        groupBuilder.MapGet(GetWhoisDomain, "GetWhoisDomain").AllowAnonymous();
    }

    [EndpointSummary("GetWhoisDomain")]
    [EndpointDescription("RDAP/WHOIS registration data for a domain name.")]
    public static async Task<Ok<ErrorExceptionResult<WhoisDomainDto>>> GetWhoisDomain(ISender sender, string domain)
    {
        var data = await sender.Send(new GetWhoisDomainQuery(domain));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetWhoisIp")]
    [EndpointDescription("RDAP/WHOIS registration data for an IP address.")]
    public static async Task<Ok<ErrorExceptionResult<WhoisIpDto>>> GetWhoisIp(ISender sender, string address)
    {
        var data = await sender.Send(new GetWhoisIpQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }
}
