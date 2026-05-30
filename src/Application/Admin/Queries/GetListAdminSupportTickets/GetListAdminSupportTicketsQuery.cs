using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;
using Ntk.Note.IP.Domain.Enums;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminSupportTickets;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminSupportTicketsQuery(bool OpenOnly = false) : IRequest<IReadOnlyList<AdminSupportTicketDto>>;

public class GetListAdminSupportTicketsQueryHandler
    : IRequestHandler<GetListAdminSupportTicketsQuery, IReadOnlyList<AdminSupportTicketDto>>
{
    private readonly IApplicationDbContext _context;

    public GetListAdminSupportTicketsQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IReadOnlyList<AdminSupportTicketDto>> Handle(
        GetListAdminSupportTicketsQuery request,
        CancellationToken cancellationToken)
    {
        var query = _context.SupportTickets.AsNoTracking();

        if (request.OpenOnly)
        {
            query = query.Where(t => t.Status == SupportTicketStatus.Open);
        }

        return await query
            .OrderByDescending(t => t.Created)
            .Select(t => new AdminSupportTicketDto
            {
                Id = t.Id,
                Name = t.Name,
                Email = t.Email,
                Subject = t.Subject,
                Message = t.Message,
                Status = t.Status.ToString(),
                EmailSent = t.EmailSent,
                EmailError = t.EmailError,
                UserId = t.UserId,
                Created = t.Created,
            })
            .ToListAsync(cancellationToken);
    }
}
