using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminUsers;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminUsersQuery : IRequest<IReadOnlyList<AdminUserDto>>;

public class GetListAdminUsersQueryHandler : IRequestHandler<GetListAdminUsersQuery, IReadOnlyList<AdminUserDto>>
{
    private readonly IAdminUserService _adminUsers;

    public GetListAdminUsersQueryHandler(IAdminUserService adminUsers)
    {
        _adminUsers = adminUsers;
    }

    public Task<IReadOnlyList<AdminUserDto>> Handle(GetListAdminUsersQuery request, CancellationToken cancellationToken) =>
        _adminUsers.GetListAsync(cancellationToken);
}
