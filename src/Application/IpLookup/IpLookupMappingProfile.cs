using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Application.IpLookup;

public class IpLookupMappingProfile : Profile
{
    public IpLookupMappingProfile()
    {
        CreateMap<IpLookupRecord, IpLookupRecordDto>();
    }
}
