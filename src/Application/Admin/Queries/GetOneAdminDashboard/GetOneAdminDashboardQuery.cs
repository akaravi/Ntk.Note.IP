using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetOneAdminDashboard;

[Authorize(Roles = Roles.Administrator)]
public record GetOneAdminDashboardQuery : IRequest<AdminDashboardDto>;

public class GetOneAdminDashboardQueryHandler : IRequestHandler<GetOneAdminDashboardQuery, AdminDashboardDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IAdminUserService _adminUsers;
    private readonly IAdminRoleService _adminRoles;

    public GetOneAdminDashboardQueryHandler(
        IApplicationDbContext context,
        IAdminUserService adminUsers,
        IAdminRoleService adminRoles)
    {
        _context = context;
        _adminUsers = adminUsers;
        _adminRoles = adminRoles;
    }

    public async Task<AdminDashboardDto> Handle(GetOneAdminDashboardQuery request, CancellationToken cancellationToken)
    {
        var users = await _adminUsers.GetListAsync(cancellationToken);
        var roles = await _adminRoles.GetListAsync(cancellationToken);

        return new AdminDashboardDto
        {
            UserCount = users.Count,
            RoleCount = roles.Count,
            IpNoteCount = await _context.IpNotes.CountAsync(cancellationToken),
            IpLookupRecordCount = await _context.IpLookupRecords.CountAsync(cancellationToken),
            PushDeviceCount = await _context.PushDeviceRegistrations.CountAsync(cancellationToken),
            OutboxPendingCount = await _context.OutboxMessages
                .CountAsync(m => m.ProcessedOn == null, cancellationToken),
            IpSnapshotCount = await _context.UserPublicIpSnapshots.CountAsync(cancellationToken),
            SupportTicketOpenCount = await _context.SupportTickets
                .CountAsync(t => t.Status == Domain.Enums.SupportTicketStatus.Open, cancellationToken),
        };
    }
}
