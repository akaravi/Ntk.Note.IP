using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetGeoLocation;

public record GetGeoLocationQuery(string Address) : IRequest<GeoLocationDto>, IIpAddressQuery;

public class GetGeoLocationQueryValidator : IpAddressQueryValidator<GetGeoLocationQuery>;

public class GetGeoLocationQueryHandler : IRequestHandler<GetGeoLocationQuery, GeoLocationDto>
{
    private readonly IIpLookupProvider _lookupProvider;

    public GetGeoLocationQueryHandler(IIpLookupProvider lookupProvider)
    {
        _lookupProvider = lookupProvider;
    }

    public async Task<GeoLocationDto> Handle(GetGeoLocationQuery request, CancellationToken cancellationToken)
    {
        var (_, lookup) = await IpLookupQueryHelper.ResolveLookupAsync(
            request.Address,
            _lookupProvider,
            cancellationToken);

        return IpLookupMapper.ToGeoLocation(lookup);
    }
}
