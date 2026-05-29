using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Dns;

namespace Ntk.Note.IP.Application.IpTools.Queries.GetSslCertificateInfo;

public record GetSslCertificateInfoQuery(string Domain, int Port = 443) : IRequest<SslCertificateInfoDto>;

public class GetSslCertificateInfoQueryValidator : AbstractValidator<GetSslCertificateInfoQuery>
{
    public GetSslCertificateInfoQueryValidator()
    {
        RuleFor(v => v.Domain)
            .NotEmpty()
            .Must(d => DomainNameValidator.TryNormalize(d, out _))
            .WithMessage("A valid domain name is required.");

        RuleFor(v => v.Port).InclusiveBetween(1, 65535);
    }
}

public class GetSslCertificateInfoQueryHandler : IRequestHandler<GetSslCertificateInfoQuery, SslCertificateInfoDto>
{
    private readonly ISslCertificateService _sslCertificateService;

    public GetSslCertificateInfoQueryHandler(ISslCertificateService sslCertificateService)
    {
        _sslCertificateService = sslCertificateService;
    }

    public Task<SslCertificateInfoDto> Handle(GetSslCertificateInfoQuery request, CancellationToken cancellationToken)
    {
        if (!DomainNameValidator.TryNormalize(request.Domain, out var domain))
        {
            throw new InvalidOperationException("Invalid domain.");
        }

        return _sslCertificateService.GetCertificateAsync(domain, request.Port, cancellationToken);
    }
}
