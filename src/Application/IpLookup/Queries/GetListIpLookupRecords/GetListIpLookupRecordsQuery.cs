using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetListIpLookupRecords;

[Authorize]
public record GetListIpLookupRecordsQuery : IRequest<List<IpLookupRecordDto>>;

public class GetListIpLookupRecordsQueryHandler : IRequestHandler<GetListIpLookupRecordsQuery, List<IpLookupRecordDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetListIpLookupRecordsQueryHandler(IApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<List<IpLookupRecordDto>> Handle(GetListIpLookupRecordsQuery request, CancellationToken cancellationToken)
    {
        return await _context.IpLookupRecords
            .AsNoTracking()
            .OrderByDescending(r => r.Id)
            .ProjectTo<IpLookupRecordDto>(_mapper.ConfigurationProvider)
            .ToListAsync(cancellationToken);
    }
}
