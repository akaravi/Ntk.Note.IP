using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.Dns.Queries.ResolveDns;

public record ResolveDnsQuery : IRequest<DnsResolveResultDto>
{
    public string Domain { get; init; } = string.Empty;

    public string[]? Types { get; init; }
}

public class ResolveDnsQueryValidator : AbstractValidator<ResolveDnsQuery>
{
    public ResolveDnsQueryValidator()
    {
        RuleFor(v => v.Domain)
            .NotEmpty()
            .Must(d => DomainNameValidator.TryNormalize(d, out _))
            .WithMessage("A valid domain name is required.");
    }
}

public class ResolveDnsQueryHandler : IRequestHandler<ResolveDnsQuery, DnsResolveResultDto>
{
    private static readonly DnsRecordType[] DefaultTypes =
    [
        DnsRecordType.A,
        DnsRecordType.Aaaa,
        DnsRecordType.Mx,
        DnsRecordType.Txt,
        DnsRecordType.Ns,
        DnsRecordType.Cname
    ];

    private readonly IDnsResolutionService _dnsResolutionService;

    public ResolveDnsQueryHandler(IDnsResolutionService dnsResolutionService)
    {
        _dnsResolutionService = dnsResolutionService;
    }

    public Task<DnsResolveResultDto> Handle(ResolveDnsQuery request, CancellationToken cancellationToken)
    {
        if (!DomainNameValidator.TryNormalize(request.Domain, out var domain))
        {
            throw new InvalidOperationException("Invalid domain.");
        }

        var types = ParseTypes(request.Types);
        return _dnsResolutionService.ResolveAsync(domain, types, cancellationToken);
    }

    private static IReadOnlyCollection<DnsRecordType> ParseTypes(string[]? types)
    {
        if (types is null or { Length: 0 })
        {
            return DefaultTypes;
        }

        var parsed = new List<DnsRecordType>();
        foreach (var raw in types)
        {
            if (Enum.TryParse<DnsRecordType>(raw.Trim(), ignoreCase: true, out var type))
            {
                parsed.Add(type);
            }
        }

        return parsed.Count > 0 ? parsed : DefaultTypes;
    }
}
