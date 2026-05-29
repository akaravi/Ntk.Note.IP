using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Web.Services;

public class ClientIpResolver : IClientIpResolver
{
    private readonly IHttpContextAccessor _httpContextAccessor;

    public ClientIpResolver(IHttpContextAccessor httpContextAccessor)
    {
        _httpContextAccessor = httpContextAccessor;
    }

    public string? GetClientIpAddress()
    {
        var context = _httpContextAccessor.HttpContext;
        if (context is null)
        {
            return null;
        }

        var forwarded = context.Request.Headers["X-Forwarded-For"].FirstOrDefault();
        if (!string.IsNullOrWhiteSpace(forwarded))
        {
            var firstHop = forwarded.Split(',')[0].Trim();
            if (IpAddress.TryParse(firstHop, out var forwardedIp) && forwardedIp is not null)
            {
                return forwardedIp.Value;
            }
        }

        var remote = context.Connection.RemoteIpAddress;
        if (remote is null)
        {
            return null;
        }

        if (remote.IsIPv4MappedToIPv6)
        {
            remote = remote.MapToIPv4();
        }

        return remote.ToString();
    }
}
