using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetListIpLookupRecords;

[Authorize]
public record GetListIpLookupRecordsQuery : IRequest<List<IpLookupRecordDto>>;

public class GetListIpLookupRecordsQueryHandler : IRequestHandler<GetListIpLookupRecordsQuery, List<IpLookupRecordDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;
    private readonly IUser _user;

    public GetListIpLookupRecordsQueryHandler(IApplicationDbContext context, IMapper mapper, IUser user)
    {
        _context = context;
        _mapper = mapper;
        _user = user;
    }

    public async Task<List<IpLookupRecordDto>> Handle(GetListIpLookupRecordsQuery request, CancellationToken cancellationToken)
    {
        var query = _context.IpLookupRecords.AsNoTracking();

        if (!IsAdministrator(_user))
        {
            var userId = IpNoteUserScope.RequireUserId(_user);
            query = query.Where(r => r.CreatedBy == userId);
        }

        return await query
            .OrderByDescending(r => r.Id)
            .ProjectTo<IpLookupRecordDto>(_mapper.ConfigurationProvider)
            .ToListAsync(cancellationToken);
    }

    private static bool IsAdministrator(IUser user) =>
        user.Roles?.Contains(Roles.Administrator) == true;
}
