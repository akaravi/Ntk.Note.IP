using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IApplicationDbContext
{
    DbSet<IpNote> IpNotes { get; }

    DbSet<IpLookupRecord> IpLookupRecords { get; }

    DbSet<IpRecord> IpRecords { get; }

    DbSet<OutboxMessage> OutboxMessages { get; }

    DbSet<PushDeviceRegistration> PushDeviceRegistrations { get; }

    DbSet<UserPublicIpSnapshot> UserPublicIpSnapshots { get; }

    Task<int> SaveChangesAsync(CancellationToken cancellationToken);
}
