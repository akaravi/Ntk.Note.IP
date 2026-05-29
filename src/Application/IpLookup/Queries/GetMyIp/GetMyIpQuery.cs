using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetMyIp;

public record GetMyIpQuery : IRequest<MyIpDto>;

public class GetMyIpQueryHandler : IRequestHandler<GetMyIpQuery, MyIpDto>
{
    private readonly IClientIpResolver _clientIpResolver;

    public GetMyIpQueryHandler(IClientIpResolver clientIpResolver)
    {
        _clientIpResolver = clientIpResolver;
    }

    public Task<MyIpDto> Handle(GetMyIpQuery request, CancellationToken cancellationToken)
    {
        var raw = _clientIpResolver.GetClientIpAddress();
        if (string.IsNullOrWhiteSpace(raw) || !IpAddress.TryParse(raw, out var ip) || ip is null)
        {
            throw new InvalidOperationException("Could not determine client IP address.");
        }

        return Task.FromResult(new MyIpDto
        {
            Address = ip.Value,
            Scope = ip.GetScope(),
            IsIPv6 = ip.IsIPv6
        });
    }
}
