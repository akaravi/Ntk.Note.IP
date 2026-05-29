using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Application.IpLookup.Commands.ActionLookupIp;
using Ntk.Note.IP.Application.IpLookup.Commands.ActionMonitorMyIp;
using Ntk.Note.IP.Application.IpLookup.Queries.GetAsnInfo;
using Ntk.Note.IP.Application.IpLookup.Queries.GetGeoLocation;
using Ntk.Note.IP.Application.IpLookup.Queries.GetIpDetails;
using Ntk.Note.IP.Application.IpLookup.Queries.GetListIpLookupRecords;
using Ntk.Note.IP.Application.IpLookup.Queries.GetMyIp;
using Ntk.Note.IP.Application.IpLookup.Queries.GetOneIpLookupRecord;
using Ntk.Note.IP.Application.IpLookup.Queries.GetReverseDns;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class IpLookup : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.GuestApi);

        groupBuilder.MapGet(GetMyIp, "GetMyIp").AllowAnonymous();
        groupBuilder.MapGet(GetMyIpPlain, "GetMyIpPlain")
            .AllowAnonymous()
            .Produces<string>(StatusCodes.Status200OK, "text/plain");
        groupBuilder.MapGet(GetIpDetails, "GetIpDetails").AllowAnonymous();
        groupBuilder.MapGet(GetGeoLocation, "GetGeoLocation").AllowAnonymous();
        groupBuilder.MapGet(GetAsnInfo, "GetAsnInfo").AllowAnonymous();
        groupBuilder.MapGet(GetReverseDns, "GetReverseDns").AllowAnonymous();
        groupBuilder.MapPost(ActionLookup, "ActionLookup").AllowAnonymous();

        groupBuilder.RequireAuthorization();

        groupBuilder.MapPost(ActionMonitorMyIp, "ActionMonitorMyIp");
        groupBuilder.MapGet(GetListIpLookupRecords);
        groupBuilder.MapGet(GetOneIpLookupRecord, "{id}");
    }

    [EndpointSummary("GetMyIp")]
    [EndpointDescription("Returns the caller's IP address and scope (public/private/loopback).")]
    public static async Task<Ok<ErrorExceptionResult<MyIpDto>>> GetMyIp(ISender sender)
    {
        var data = await sender.Send(new GetMyIpQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetMyIpPlain")]
    [EndpointDescription("Returns the caller IP address as plain text (curl-friendly).")]
    public static async Task<ContentHttpResult> GetMyIpPlain(ISender sender)
    {
        var data = await sender.Send(new GetMyIpQuery());
        return TypedResults.Content(data.Address, "text/plain");
    }

    [EndpointSummary("GetIpDetails")]
    [EndpointDescription("Geo, ASN, ISP and reverse DNS for an IP address.")]
    public static async Task<Ok<ErrorExceptionResult<IpDetailsDto>>> GetIpDetails(ISender sender, string address)
    {
        var data = await sender.Send(new GetIpDetailsQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetGeoLocation")]
    [EndpointDescription("Geolocation for an IP address.")]
    public static async Task<Ok<ErrorExceptionResult<GeoLocationDto>>> GetGeoLocation(ISender sender, string address)
    {
        var data = await sender.Send(new GetGeoLocationQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetAsnInfo")]
    [EndpointDescription("ASN and organization for an IP address.")]
    public static async Task<Ok<ErrorExceptionResult<AsnInfoDto>>> GetAsnInfo(ISender sender, string address)
    {
        var data = await sender.Send(new GetAsnInfoQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetReverseDns")]
    [EndpointDescription("PTR reverse DNS hostname for an IP address.")]
    public static async Task<Ok<ErrorExceptionResult<ReverseDnsDto>>> GetReverseDns(ISender sender, string address)
    {
        var data = await sender.Send(new GetReverseDnsQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionLookup IP")]
    [EndpointDescription("Runs an external geo/ASN lookup for the given IP and stores the result.")]
    public static async Task<Created<ErrorExceptionResult<IpLookupRecordDto>>> ActionLookup(
        ISender sender,
        ActionLookupIpCommand command)
    {
        var record = await sender.Send(command);
        return ApiEnvelopeResults.Created($"{ApiRoutes.Group(nameof(IpLookup))}/{record.Id}", record);
    }

    [EndpointSummary("ActionMonitorMyIp")]
    [EndpointDescription("Records the caller public IP for the authenticated user and sends push when it changes.")]
    public static async Task<Ok<ErrorExceptionResult<MonitorMyIpResultDto>>> ActionMonitorMyIp(ISender sender)
    {
        var data = await sender.Send(new ActionMonitorMyIpCommand());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetList IP lookup history")]
    [EndpointDescription("Returns cached lookup records as a homogeneous list in data.")]
    public static async Task<Ok<ErrorExceptionResult<List<IpLookupRecordDto>>>> GetListIpLookupRecords(ISender sender)
    {
        var data = await sender.Send(new GetListIpLookupRecordsQuery());
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetOne IP lookup record")]
    [EndpointDescription("Returns a single lookup record by id.")]
    public static async Task<Ok<ErrorExceptionResult<IpLookupRecordDto>>> GetOneIpLookupRecord(ISender sender, int id)
    {
        var data = await sender.Send(new GetOneIpLookupRecordQuery(id));
        return ApiEnvelopeResults.Ok(data);
    }
}
