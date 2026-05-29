using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.Entities;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup.Commands.ActionLookupIp;

public record ActionLookupIpCommand : IRequest<IpLookupRecordDto>
{
    public string Address { get; init; } = string.Empty;
}

public class ActionLookupIpCommandHandler : IRequestHandler<ActionLookupIpCommand, IpLookupRecordDto>
{
    private readonly IApplicationDbContext _context;
    private readonly IIpLookupProvider _lookupProvider;
    private readonly IMapper _mapper;

    public ActionLookupIpCommandHandler(
        IApplicationDbContext context,
        IIpLookupProvider lookupProvider,
        IMapper mapper)
    {
        _context = context;
        _lookupProvider = lookupProvider;
        _mapper = mapper;
    }

    public async Task<IpLookupRecordDto> Handle(ActionLookupIpCommand request, CancellationToken cancellationToken)
    {
        var ip = IpAddress.Parse(request.Address);
        var result = await _lookupProvider.LookupAsync(ip.Value, cancellationToken);

        var entity = new IpLookupRecord
        {
            Address = ip.Value,
            CountryCode = result.CountryCode,
            Region = result.Region,
            City = result.City,
            Asn = result.Asn,
            Isp = result.Isp,
            ProviderPayload = result.ProviderPayload
        };

        _context.IpLookupRecords.Add(entity);
        await _context.SaveChangesAsync(cancellationToken);

        return _mapper.Map<IpLookupRecordDto>(entity);
    }
}
