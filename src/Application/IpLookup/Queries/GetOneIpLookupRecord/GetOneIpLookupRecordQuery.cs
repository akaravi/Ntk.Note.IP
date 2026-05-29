using Ntk.Note.IP.Application.Common.Exceptions;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpNotes;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetOneIpLookupRecord;

[Authorize]
public record GetOneIpLookupRecordQuery(int Id) : IRequest<IpLookupRecordDto>;

public class GetOneIpLookupRecordQueryHandler : IRequestHandler<GetOneIpLookupRecordQuery, IpLookupRecordDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;
    private readonly IUser _user;

    public GetOneIpLookupRecordQueryHandler(IApplicationDbContext context, IMapper mapper, IUser user)
    {
        _context = context;
        _mapper = mapper;
        _user = user;
    }

    public async Task<IpLookupRecordDto> Handle(GetOneIpLookupRecordQuery request, CancellationToken cancellationToken)
    {
        var entity = await _context.IpLookupRecords
            .AsNoTracking()
            .Where(r => r.Id == request.Id)
            .ProjectTo<IpLookupRecordDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync(cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        if (!IsAdministrator(_user))
        {
            var userId = IpNoteUserScope.RequireUserId(_user);
            var ownerId = await _context.IpLookupRecords
                .AsNoTracking()
                .Where(r => r.Id == request.Id)
                .Select(r => r.CreatedBy)
                .FirstAsync(cancellationToken);

            if (!string.Equals(ownerId, userId, StringComparison.Ordinal))
            {
                throw new ForbiddenAccessException();
            }
        }

        return entity;
    }

    private static bool IsAdministrator(IUser user) =>
        user.Roles?.Contains(Roles.Administrator) == true;
}
