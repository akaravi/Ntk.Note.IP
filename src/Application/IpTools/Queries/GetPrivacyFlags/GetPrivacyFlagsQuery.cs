using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpTools.Queries.GetPrivacyFlags;

public record GetPrivacyFlagsQuery(string Address) : IRequest<PrivacyFlagsDto>, IIpAddressQuery;

public class GetPrivacyFlagsQueryValidator : IpAddressQueryValidator<GetPrivacyFlagsQuery>;

public class GetPrivacyFlagsQueryHandler : IRequestHandler<GetPrivacyFlagsQuery, PrivacyFlagsDto>
{
    private readonly IIpLookupProvider _lookupProvider;

    public GetPrivacyFlagsQueryHandler(IIpLookupProvider lookupProvider)
    {
        _lookupProvider = lookupProvider;
    }

    public async Task<PrivacyFlagsDto> Handle(GetPrivacyFlagsQuery request, CancellationToken cancellationToken)
    {
        var ip = IpAddress.Parse(request.Address);
        var lookup = await _lookupProvider.LookupAsync(ip.Value, cancellationToken);

        return new PrivacyFlagsDto
        {
            Address = ip.Value,
            Proxy = lookup.Proxy ?? false,
            Hosting = lookup.Hosting ?? false,
            Mobile = lookup.Mobile ?? false,
            Tor = lookup.Tor ?? false
        };
    }
}
