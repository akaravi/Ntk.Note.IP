using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.Blacklist.Queries.GetListBlacklist;

public record GetListBlacklistQuery(string Address) : IRequest<List<BlacklistHitDto>>, IIpAddressQuery;

public class GetListBlacklistQueryValidator : IpAddressQueryValidator<GetListBlacklistQuery>;

public class GetListBlacklistQueryHandler : IRequestHandler<GetListBlacklistQuery, List<BlacklistHitDto>>
{
    private readonly IBlacklistChecker _blacklistChecker;

    public GetListBlacklistQueryHandler(IBlacklistChecker blacklistChecker)
    {
        _blacklistChecker = blacklistChecker;
    }

    public async Task<List<BlacklistHitDto>> Handle(GetListBlacklistQuery request, CancellationToken cancellationToken)
    {
        var ip = IpAddress.Parse(request.Address);
        var hits = await _blacklistChecker.CheckAsync(ip.Value, cancellationToken);
        return [..hits];
    }
}
