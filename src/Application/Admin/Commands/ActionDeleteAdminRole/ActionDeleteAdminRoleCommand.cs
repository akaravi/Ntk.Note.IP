using FluentValidation.Results;
using AppValidationException = Ntk.Note.IP.Application.Common.Exceptions.ValidationException;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionDeleteAdminRole;

[Authorize(Roles = Roles.Administrator)]
public record ActionDeleteAdminRoleCommand(string RoleId) : IRequest;

public class ActionDeleteAdminRoleCommandValidator : AbstractValidator<ActionDeleteAdminRoleCommand>
{
    public ActionDeleteAdminRoleCommandValidator()
    {
        RuleFor(command => command.RoleId).NotEmpty();
    }
}

public class ActionDeleteAdminRoleCommandHandler : IRequestHandler<ActionDeleteAdminRoleCommand>
{
    private readonly IAdminRoleService _adminRoles;

    public ActionDeleteAdminRoleCommandHandler(IAdminRoleService adminRoles)
    {
        _adminRoles = adminRoles;
    }

    public async Task Handle(ActionDeleteAdminRoleCommand request, CancellationToken cancellationToken)
    {
        var result = await _adminRoles.DeleteAsync(request.RoleId, cancellationToken);

        if (!result.Succeeded)
        {
            throw new AppValidationException(result.Errors.Select(error => new ValidationFailure(string.Empty, error)));
        }
    }
}
