using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Dns;

namespace Ntk.Note.IP.Application.Whois.Queries.GetWhoisDomain;

public record GetWhoisDomainQuery(string Domain) : IRequest<WhoisDomainDto>;

public class GetWhoisDomainQueryValidator : AbstractValidator<GetWhoisDomainQuery>
{
    public GetWhoisDomainQueryValidator()
    {
        RuleFor(v => v.Domain)
            .NotEmpty()
            .Must(d => DomainNameValidator.TryNormalize(d, out _))
            .WithMessage("A valid domain name is required.");
    }
}

public class GetWhoisDomainQueryHandler : IRequestHandler<GetWhoisDomainQuery, WhoisDomainDto>
{
    private readonly IWhoisProvider _whoisProvider;

    public GetWhoisDomainQueryHandler(IWhoisProvider whoisProvider)
    {
        _whoisProvider = whoisProvider;
    }

    public Task<WhoisDomainDto> Handle(GetWhoisDomainQuery request, CancellationToken cancellationToken)
    {
        if (!DomainNameValidator.TryNormalize(request.Domain, out var domain))
        {
            throw new InvalidOperationException("Invalid domain.");
        }

        return _whoisProvider.LookupDomainAsync(domain, cancellationToken);
    }
}
