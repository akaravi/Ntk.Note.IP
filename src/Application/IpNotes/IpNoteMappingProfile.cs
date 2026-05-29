using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Application.IpNotes;

public class IpNoteMappingProfile : Profile
{
    public IpNoteMappingProfile()
    {
        CreateMap<IpNote, IpNoteDto>()
            .ForMember(d => d.DeviceInfo, o => o.MapFrom(s => IpNoteSnapshotJson.DeserializeDevice(s.DeviceInfoJson)))
            .ForMember(d => d.IpSnapshot, o => o.MapFrom(s => IpNoteSnapshotJson.DeserializeIpSnapshot(s.IpSnapshotJson)));
    }
}
