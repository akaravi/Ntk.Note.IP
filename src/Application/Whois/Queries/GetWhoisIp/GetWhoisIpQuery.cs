using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.Whois.Queries.GetWhoisIp;

public record GetWhoisIpQuery(string Address) : IRequest<WhoisIpDto>, IIpAddressQuery;

public class GetWhoisIpQueryValidator : IpAddressQueryValidator<GetWhoisIpQuery>;

public class GetWhoisIpQueryHandler : IRequestHandler<GetWhoisIpQuery, WhoisIpDto>
{
    private readonly IWhoisProvider _whoisProvider;

    public GetWhoisIpQueryHandler(IWhoisProvider whoisProvider)
    {
        _whoisProvider = whoisProvider;
    }

    public Task<WhoisIpDto> Handle(GetWhoisIpQuery request, CancellationToken cancellationToken)
    {
        var ip = IpAddress.Parse(request.Address);
        return _whoisProvider.LookupIpAsync(ip.Value, cancellationToken);
    }
}
