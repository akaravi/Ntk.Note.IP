using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminPushDevices;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminPushDevicesQuery : IRequest<List<AdminPushDeviceDto>>;

public class GetListAdminPushDevicesQueryHandler : IRequestHandler<GetListAdminPushDevicesQuery, List<AdminPushDeviceDto>>
{
    private readonly IApplicationDbContext _context;

    public GetListAdminPushDevicesQueryHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<List<AdminPushDeviceDto>> Handle(GetListAdminPushDevicesQuery request, CancellationToken cancellationToken)
    {
        return await _context.PushDeviceRegistrations
            .AsNoTracking()
            .OrderByDescending(p => p.Id)
            .Take(500)
            .Select(p => new AdminPushDeviceDto
            {
                Id = p.Id,
                DeviceToken = p.DeviceToken,
                Platform = p.Platform,
                OwnerId = p.CreatedBy,
                Created = p.Created,
                LastModified = p.LastModified,
            })
            .ToListAsync(cancellationToken);
    }
}
