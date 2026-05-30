using Ntk.Note.IP.Application.Admin;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminPermissions;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminPermissionsQuery : IRequest<IReadOnlyList<AdminPermissionCatalogItemDto>>;

public class GetListAdminPermissionsQueryHandler
    : IRequestHandler<GetListAdminPermissionsQuery, IReadOnlyList<AdminPermissionCatalogItemDto>>
{
    private readonly IAdminRoleService _adminRoles;

    public GetListAdminPermissionsQueryHandler(IAdminRoleService adminRoles)
    {
        _adminRoles = adminRoles;
    }

    public Task<IReadOnlyList<AdminPermissionCatalogItemDto>> Handle(
        GetListAdminPermissionsQuery request,
        CancellationToken cancellationToken)
    {
        return Task.FromResult(_adminRoles.GetPermissionCatalog());
    }
}
