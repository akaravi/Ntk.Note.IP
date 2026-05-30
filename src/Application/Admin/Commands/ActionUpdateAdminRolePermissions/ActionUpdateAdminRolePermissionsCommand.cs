using FluentValidation.Results;
using AppValidationException = Ntk.Note.IP.Application.Common.Exceptions.ValidationException;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionUpdateAdminRolePermissions;

[Authorize(Roles = Roles.Administrator)]
public record ActionUpdateAdminRolePermissionsCommand : IRequest
{
    public string RoleId { get; init; } = string.Empty;

    public IReadOnlyList<string> Permissions { get; init; } = [];
}

public class ActionUpdateAdminRolePermissionsCommandValidator : AbstractValidator<ActionUpdateAdminRolePermissionsCommand>
{
    public ActionUpdateAdminRolePermissionsCommandValidator()
    {
        RuleFor(command => command.RoleId).NotEmpty();
    }
}

public class ActionUpdateAdminRolePermissionsCommandHandler : IRequestHandler<ActionUpdateAdminRolePermissionsCommand>
{
    private readonly IAdminRoleService _adminRoles;

    public ActionUpdateAdminRolePermissionsCommandHandler(IAdminRoleService adminRoles)
    {
        _adminRoles = adminRoles;
    }

    public async Task Handle(ActionUpdateAdminRolePermissionsCommand request, CancellationToken cancellationToken)
    {
        var result = await _adminRoles.UpdatePermissionsAsync(
            request.RoleId,
            request.Permissions,
            cancellationToken);

        if (!result.Succeeded)
        {
            throw new AppValidationException(result.Errors.Select(error => new ValidationFailure(string.Empty, error)));
        }
    }
}
