using FluentValidation.Results;
using AppValidationException = Ntk.Note.IP.Application.Common.Exceptions.ValidationException;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionSetAdminUserRoles;

[Authorize(Roles = Domain.Constants.Roles.Administrator)]
public record ActionSetAdminUserRolesCommand : IRequest
{
    public string UserId { get; init; } = string.Empty;

    public IReadOnlyList<string> Roles { get; init; } = [];
}

public class ActionSetAdminUserRolesCommandValidator : AbstractValidator<ActionSetAdminUserRolesCommand>
{
    public ActionSetAdminUserRolesCommandValidator()
    {
        RuleFor(v => v.UserId).NotEmpty();
    }
}

public class ActionSetAdminUserRolesCommandHandler : IRequestHandler<ActionSetAdminUserRolesCommand>
{
    private readonly IAdminUserService _adminUsers;

    public ActionSetAdminUserRolesCommandHandler(IAdminUserService adminUsers)
    {
        _adminUsers = adminUsers;
    }

    public async Task Handle(ActionSetAdminUserRolesCommand request, CancellationToken cancellationToken)
    {
        var result = await _adminUsers.SetRolesAsync(request.UserId, request.Roles, cancellationToken);

        if (!result.Succeeded)
        {
            throw new AppValidationException(result.Errors.Select(e => new ValidationFailure(string.Empty, e)));
        }
    }
}
