using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup.Queries.GetReverseDns;

public record GetReverseDnsQuery(string Address) : IRequest<ReverseDnsDto>, IIpAddressQuery;

public class ReverseDnsDto
{
    public string Address { get; init; } = string.Empty;

    public string? HostName { get; init; }
}

public class GetReverseDnsQueryValidator : IpAddressQueryValidator<GetReverseDnsQuery>;

public class GetReverseDnsQueryHandler : IRequestHandler<GetReverseDnsQuery, ReverseDnsDto>
{
    private readonly IDnsLookupService _dnsLookupService;

    public GetReverseDnsQueryHandler(IDnsLookupService dnsLookupService)
    {
        _dnsLookupService = dnsLookupService;
    }

    public async Task<ReverseDnsDto> Handle(GetReverseDnsQuery request, CancellationToken cancellationToken)
    {
        var ip = IpAddress.Parse(request.Address);
        var hostName = await _dnsLookupService.GetReverseDnsAsync(ip.Value, cancellationToken);

        return new ReverseDnsDto
        {
            Address = ip.Value,
            HostName = hostName
        };
    }
}
