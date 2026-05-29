using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.Dns;
using Ntk.Note.IP.Application.Dns.Queries.GetListDnsPropagation;
using Ntk.Note.IP.Application.Dns.Queries.ResolveDns;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class Dns : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.GuestApi);

        groupBuilder.MapGet(ResolveDns, "ResolveDns").AllowAnonymous();
        groupBuilder.MapGet(GetListDnsPropagation, "GetListDnsPropagation").AllowAnonymous();
    }

    [EndpointSummary("GetListDnsPropagation")]
    [EndpointDescription("Compares DNS answers across public resolvers (Google, Cloudflare, Quad9).")]
    public static async Task<Ok<ErrorExceptionResult<DnsPropagationResultDto>>> GetListDnsPropagation(
        ISender sender,
        string domain,
        string type = "A")
    {
        var data = await sender.Send(new GetListDnsPropagationQuery { Domain = domain, Type = type });
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ResolveDns")]
    [EndpointDescription("Resolves DNS records (A, AAAA, MX, TXT, NS, CNAME, SOA) for a domain.")]
    public static async Task<Ok<ErrorExceptionResult<DnsResolveResultDto>>> ResolveDns(
        ISender sender,
        string domain,
        string[]? types)
    {
        var data = await sender.Send(new ResolveDnsQuery { Domain = domain, Types = types });
        return ApiEnvelopeResults.Ok(data);
    }
}
