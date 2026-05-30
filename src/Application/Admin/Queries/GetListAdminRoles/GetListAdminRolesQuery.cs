using Ntk.Note.IP.Application.Admin;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminRoles;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminRolesQuery : IRequest<IReadOnlyList<AdminRoleDto>>;

public class GetListAdminRolesQueryHandler : IRequestHandler<GetListAdminRolesQuery, IReadOnlyList<AdminRoleDto>>
{
    private readonly IAdminRoleService _adminRoles;

    public GetListAdminRolesQueryHandler(IAdminRoleService adminRoles)
    {
        _adminRoles = adminRoles;
    }

    public Task<IReadOnlyList<AdminRoleDto>> Handle(GetListAdminRolesQuery request, CancellationToken cancellationToken)
    {
        return _adminRoles.GetListAsync(cancellationToken);
    }
}
