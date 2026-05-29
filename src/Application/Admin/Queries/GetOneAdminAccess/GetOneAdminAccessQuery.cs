using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetOneAdminAccess;

[Authorize]
public record GetOneAdminAccessQuery : IRequest<AdminAccessDto>;

public class GetOneAdminAccessQueryHandler : IRequestHandler<GetOneAdminAccessQuery, AdminAccessDto>
{
    private readonly IUser _user;

    public GetOneAdminAccessQueryHandler(IUser user)
    {
        _user = user;
    }

    public Task<AdminAccessDto> Handle(GetOneAdminAccessQuery request, CancellationToken cancellationToken)
    {
        var roles = _user.Roles ?? [];
        var isAdministrator = roles.Contains(Roles.Administrator);

        return Task.FromResult(new AdminAccessDto
        {
            IsAdministrator = isAdministrator,
            Roles = roles,
        });
    }
}
