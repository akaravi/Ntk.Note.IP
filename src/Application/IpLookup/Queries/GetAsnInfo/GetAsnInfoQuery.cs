using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetAsnInfo;

public record GetAsnInfoQuery(string Address) : IRequest<AsnInfoDto>, IIpAddressQuery;

public class GetAsnInfoQueryValidator : IpAddressQueryValidator<GetAsnInfoQuery>;

public class GetAsnInfoQueryHandler : IRequestHandler<GetAsnInfoQuery, AsnInfoDto>
{
    private readonly IIpLookupProvider _lookupProvider;

    public GetAsnInfoQueryHandler(IIpLookupProvider lookupProvider)
    {
        _lookupProvider = lookupProvider;
    }

    public async Task<AsnInfoDto> Handle(GetAsnInfoQuery request, CancellationToken cancellationToken)
    {
        var (_, lookup) = await IpLookupQueryHelper.ResolveLookupAsync(
            request.Address,
            _lookupProvider,
            cancellationToken);

        return IpLookupMapper.ToAsnInfo(lookup);
    }
}
