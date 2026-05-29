using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetIpDetails;

public record GetIpDetailsQuery(string Address) : IRequest<IpDetailsDto>, IIpAddressQuery;

public class GetIpDetailsQueryValidator : IpAddressQueryValidator<GetIpDetailsQuery>;

public class GetIpDetailsQueryHandler : IRequestHandler<GetIpDetailsQuery, IpDetailsDto>
{
    private readonly IIpLookupProvider _lookupProvider;
    private readonly IDnsLookupService _dnsLookupService;

    public GetIpDetailsQueryHandler(IIpLookupProvider lookupProvider, IDnsLookupService dnsLookupService)
    {
        _lookupProvider = lookupProvider;
        _dnsLookupService = dnsLookupService;
    }

    public async Task<IpDetailsDto> Handle(GetIpDetailsQuery request, CancellationToken cancellationToken)
    {
        var (ip, lookup) = await IpLookupQueryHelper.ResolveLookupAsync(
            request.Address,
            _lookupProvider,
            cancellationToken);

        var reverseDns = await _dnsLookupService.GetReverseDnsAsync(ip.Value, cancellationToken);

        return IpLookupMapper.ToDetails(ip, lookup, reverseDns);
    }
}
