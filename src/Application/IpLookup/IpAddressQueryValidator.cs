using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup;

public class IpAddressQueryValidator<T> : AbstractValidator<T> where T : IIpAddressQuery
{
    public IpAddressQueryValidator()
    {
        RuleFor(v => v.Address)
            .NotEmpty()
            .Must(a => IpAddress.TryParse(a, out _))
            .WithMessage("A valid IPv4 or IPv6 address is required.");
    }
}
