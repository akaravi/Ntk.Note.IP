using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetOneIpLookupRecord;

[Authorize]
public record GetOneIpLookupRecordQuery(int Id) : IRequest<IpLookupRecordDto>;

public class GetOneIpLookupRecordQueryHandler : IRequestHandler<GetOneIpLookupRecordQuery, IpLookupRecordDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;

    public GetOneIpLookupRecordQueryHandler(IApplicationDbContext context, IMapper mapper)
    {
        _context = context;
        _mapper = mapper;
    }

    public async Task<IpLookupRecordDto> Handle(GetOneIpLookupRecordQuery request, CancellationToken cancellationToken)
    {
        var entity = await _context.IpLookupRecords
            .AsNoTracking()
            .Where(r => r.Id == request.Id)
            .ProjectTo<IpLookupRecordDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync(cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        return entity;
    }
}
