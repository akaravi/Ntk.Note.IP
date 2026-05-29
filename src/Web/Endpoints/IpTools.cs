using Ntk.Note.IP.Application.Common.Models;
using Ntk.Note.IP.Application.IpTools;
using Ntk.Note.IP.Application.IpTools.Queries.ActionCalculateSubnet;
using Ntk.Note.IP.Application.IpTools.Queries.ActionCheckPort;
using Ntk.Note.IP.Application.IpTools.Queries.ActionConvertIp;
using Ntk.Note.IP.Application.IpTools.Queries.GetPrivacyFlags;
using Ntk.Note.IP.Application.IpTools.Queries.GetSslCertificateInfo;
using Ntk.Note.IP.Web.Infrastructure;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Ntk.Note.IP.Web.Endpoints;

public class IpTools : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.GuestApi);

        groupBuilder.MapGet(GetPrivacyFlags, "GetPrivacyFlags").AllowAnonymous();
        groupBuilder.MapGet(ActionCalculateSubnet, "ActionCalculateSubnet").AllowAnonymous();
        groupBuilder.MapGet(ActionCheckPort, "ActionCheckPort").AllowAnonymous();
        groupBuilder.MapGet(GetSslCertificateInfo, "GetSslCertificateInfo").AllowAnonymous();
        groupBuilder.MapPost(ActionConvertIp, "ActionConvertIp").AllowAnonymous();
    }

    [EndpointSummary("GetPrivacyFlags")]
    [EndpointDescription("VPN/proxy/hosting/mobile flags for an IP (from lookup provider).")]
    public static async Task<Ok<ErrorExceptionResult<PrivacyFlagsDto>>> GetPrivacyFlags(ISender sender, string address)
    {
        var data = await sender.Send(new GetPrivacyFlagsQuery(address));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionCalculateSubnet")]
    [EndpointDescription("IPv4 CIDR calculator (network, broadcast, usable hosts).")]
    public static async Task<Ok<ErrorExceptionResult<SubnetInfoDto>>> ActionCalculateSubnet(ISender sender, string cidr)
    {
        var data = await sender.Send(new ActionCalculateSubnetQuery(cidr));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionCheckPort")]
    [EndpointDescription("TCP connect check for host/IP and port.")]
    public static async Task<Ok<ErrorExceptionResult<PortCheckResultDto>>> ActionCheckPort(
        ISender sender,
        string host,
        int port)
    {
        var data = await sender.Send(new ActionCheckPortQuery(host, port));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("GetSslCertificateInfo")]
    [EndpointDescription("TLS certificate summary for a domain and port.")]
    public static async Task<Ok<ErrorExceptionResult<SslCertificateInfoDto>>> GetSslCertificateInfo(
        ISender sender,
        string domain,
        int port = 443)
    {
        var data = await sender.Send(new GetSslCertificateInfoQuery(domain, port));
        return ApiEnvelopeResults.Ok(data);
    }

    [EndpointSummary("ActionConvertIp")]
    [EndpointDescription("Convert between dotted IPv4, UInt32, and compressed IPv6.")]
    public static async Task<Ok<ErrorExceptionResult<ConvertIpResultDto>>> ActionConvertIp(
        ISender sender,
        ActionConvertIpQuery query)
    {
        var data = await sender.Send(query);
        return ApiEnvelopeResults.Ok(data);
    }
}
