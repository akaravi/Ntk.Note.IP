using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;

namespace Ntk.Note.IP.Application.IpNotes.Queries.GetListIpNotes;

[Authorize]
public record GetListIpNotesQuery : IRequest<List<IpNoteDto>>;

public class GetListIpNotesQueryHandler : IRequestHandler<GetListIpNotesQuery, List<IpNoteDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;
    private readonly IUser _user;

    public GetListIpNotesQueryHandler(IApplicationDbContext context, IMapper mapper, IUser user)
    {
        _context = context;
        _mapper = mapper;
        _user = user;
    }

    public async Task<List<IpNoteDto>> Handle(GetListIpNotesQuery request, CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);

        return await _context.IpNotes
            .AsNoTracking()
            .OwnedBy(userId)
            .OrderByDescending(n => n.Id)
            .ProjectTo<IpNoteDto>(_mapper.ConfigurationProvider)
            .ToListAsync(cancellationToken);
    }
}
