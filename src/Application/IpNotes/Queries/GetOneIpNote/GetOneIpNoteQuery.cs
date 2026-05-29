using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;

namespace Ntk.Note.IP.Application.IpNotes.Queries.GetOneIpNote;

[Authorize]
public record GetOneIpNoteQuery(int Id) : IRequest<IpNoteDto>;

public class GetOneIpNoteQueryHandler : IRequestHandler<GetOneIpNoteQuery, IpNoteDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IMapper _mapper;
    private readonly IUser _user;

    public GetOneIpNoteQueryHandler(IApplicationDbContext context, IMapper mapper, IUser user)
    {
        _context = context;
        _mapper = mapper;
        _user = user;
    }

    public async Task<IpNoteDto> Handle(GetOneIpNoteQuery request, CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);

        var entity = await _context.IpNotes
            .AsNoTracking()
            .OwnedBy(userId)
            .Where(n => n.Id == request.Id)
            .ProjectTo<IpNoteDto>(_mapper.ConfigurationProvider)
            .FirstOrDefaultAsync(cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        return entity;
    }
}
