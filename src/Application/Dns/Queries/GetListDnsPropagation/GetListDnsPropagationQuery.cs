using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.Dns.Queries.GetListDnsPropagation;

public record GetListDnsPropagationQuery : IRequest<DnsPropagationResultDto>
{
    public string Domain { get; init; } = string.Empty;

    public string Type { get; init; } = "A";
}

public class GetListDnsPropagationQueryValidator : AbstractValidator<GetListDnsPropagationQuery>
{
    public GetListDnsPropagationQueryValidator()
    {
        RuleFor(v => v.Domain)
            .NotEmpty()
            .Must(d => DomainNameValidator.TryNormalize(d, out _))
            .WithMessage("A valid domain name is required.");

        RuleFor(v => v.Type)
            .NotEmpty()
            .Must(t => Enum.TryParse<DnsRecordType>(t, ignoreCase: true, out _))
            .WithMessage("Type must be a supported DNS record type.");
    }
}

public class GetListDnsPropagationQueryHandler : IRequestHandler<GetListDnsPropagationQuery, DnsPropagationResultDto>
{
    private readonly IDnsPropagationChecker _dnsPropagationChecker;

    public GetListDnsPropagationQueryHandler(IDnsPropagationChecker dnsPropagationChecker)
    {
        _dnsPropagationChecker = dnsPropagationChecker;
    }

    public Task<DnsPropagationResultDto> Handle(GetListDnsPropagationQuery request, CancellationToken cancellationToken)
    {
        if (!DomainNameValidator.TryNormalize(request.Domain, out var domain))
        {
            throw new InvalidOperationException("Invalid domain.");
        }

        if (!Enum.TryParse<DnsRecordType>(request.Type, ignoreCase: true, out var recordType))
        {
            throw new InvalidOperationException("Invalid record type.");
        }

        return _dnsPropagationChecker.CheckAsync(domain, recordType, cancellationToken);
    }
}
