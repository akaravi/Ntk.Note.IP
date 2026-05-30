using Ntk.Note.IP.Application.Admin;
using Ntk.Note.IP.Application.Common.Models;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IAdminRoleService
{
    Task<IReadOnlyList<AdminRoleDto>> GetListAsync(CancellationToken cancellationToken);

    IReadOnlyList<AdminPermissionCatalogItemDto> GetPermissionCatalog();

    Task<Result> AddAsync(string name, IReadOnlyList<string> permissions, CancellationToken cancellationToken);

    Task<Result> UpdatePermissionsAsync(
        string roleId,
        IReadOnlyList<string> permissions,
        CancellationToken cancellationToken);

    Task<Result> DeleteAsync(string roleId, CancellationToken cancellationToken);
}
