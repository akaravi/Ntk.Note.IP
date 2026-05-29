using Ntk.Note.IP.Application.Admin;
using Ntk.Note.IP.Application.Common.Models;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IAdminUserService
{
    Task<IReadOnlyList<AdminUserDto>> GetListAsync(CancellationToken cancellationToken);

    Task<Result> SetRolesAsync(string userId, IReadOnlyList<string> roles, CancellationToken cancellationToken);
}
