using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup.Commands.ActionLookupIp;

public class ActionLookupIpCommandValidator : AbstractValidator<ActionLookupIpCommand>
{
    public ActionLookupIpCommandValidator()
    {
        RuleFor(v => v.Address)
            .NotEmpty()
            .Must(a => IpAddress.TryParse(a, out _))
            .WithMessage("A valid IPv4 or IPv6 address is required.");
    }
}
