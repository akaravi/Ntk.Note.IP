using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminOutboxMessages;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminOutboxMessagesQuery(bool PendingOnly = false) : IRequest<List<AdminOutboxMessageDto>>;

public class GetListAdminOutboxMessagesQueryHandler : IRequestHandler<GetListAdminOutboxMessagesQuery, List<AdminOutboxMessageDto>>
{
    private readonly IApplicationDbContext _context;

    public GetListAdminOutboxMessagesQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<AdminOutboxMessageDto>> Handle(GetListAdminOutboxMessagesQuery request, CancellationToken cancellationToken)
    {
        var query = _context.OutboxMessages.AsNoTracking();

        if (request.PendingOnly)
        {
            query = query.Where(m => m.ProcessedOn == null);
        }

        var rows = await query.ToListAsync(cancellationToken);

        return rows
            .OrderByDescending(m => m.OccurredOn)
            .Take(500)
            .Select(m => new AdminOutboxMessageDto
            {
                Id = m.Id,
                Type = m.Type,
                OccurredOn = m.OccurredOn,
                ProcessedOn = m.ProcessedOn,
                Error = m.Error,
                ContentLength = m.Content.Length,
            })
            .ToList();
    }
}
