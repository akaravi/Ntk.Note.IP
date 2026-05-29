using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminIpLookupRecords;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminIpLookupRecordsQuery(string? Search = null) : IRequest<List<IpLookupRecordDto>>;

public class GetListAdminIpLookupRecordsQueryHandler : IRequestHandler<GetListAdminIpLookupRecordsQuery, List<IpLookupRecordDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetListAdminIpLookupRecordsQueryHandler(IApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<List<IpLookupRecordDto>> Handle(GetListAdminIpLookupRecordsQuery request, CancellationToken cancellationToken)
    {
        var query = _context.IpLookupRecords.AsNoTracking();

        if (!string.IsNullOrWhiteSpace(request.Search))
        {
            var term = request.Search.Trim();
            query = query.Where(r =>
                r.Address.Contains(term) ||
                (r.City != null && r.City.Contains(term)) ||
                (r.CountryCode != null && r.CountryCode.Contains(term)));
        }

        return await query
            .OrderByDescending(r => r.Id)
            .Take(500)
            .ProjectTo<IpLookupRecordDto>(_mapper.ConfigurationProvider)
            .ToListAsync(cancellationToken);
    }
}
