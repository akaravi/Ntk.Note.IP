using FluentValidation.Results;
using AppValidationException = Ntk.Note.IP.Application.Common.Exceptions.ValidationException;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Commands.ActionAddAdminRole;

[Authorize(Roles = Roles.Administrator)]
public record ActionAddAdminRoleCommand : IRequest
{
    public string Name { get; init; } = string.Empty;

    public IReadOnlyList<string> Permissions { get; init; } = [];
}

public class ActionAddAdminRoleCommandValidator : AbstractValidator<ActionAddAdminRoleCommand>
{
    public ActionAddAdminRoleCommandValidator()
    {
        RuleFor(command => command.Name).NotEmpty().MaximumLength(64);
    }
}

public class ActionAddAdminRoleCommandHandler : IRequestHandler<ActionAddAdminRoleCommand>
{
    private readonly IAdminRoleService _adminRoles;

    public ActionAddAdminRoleCommandHandler(IAdminRoleService adminRoles)
    {
        _adminRoles = adminRoles;
    }

    public async Task Handle(ActionAddAdminRoleCommand request, CancellationToken cancellationToken)
    {
        var result = await _adminRoles.AddAsync(request.Name, request.Permissions, cancellationToken);

        if (!result.Succeeded)
        {
            throw new AppValidationException(result.Errors.Select(error => new ValidationFailure(string.Empty, error)));
        }
    }
}
