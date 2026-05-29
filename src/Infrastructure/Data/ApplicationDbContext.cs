using System.Reflection;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.Entities;
using Ntk.Note.IP.Infrastructure.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace Ntk.Note.IP.Infrastructure.Data;

public class ApplicationDbContext : IdentityDbContext<ApplicationUser>, IApplicationDbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<IpNote> IpNotes => Set<IpNote>();

    public DbSet<IpLookupRecord> IpLookupRecords => Set<IpLookupRecord>();

    public DbSet<IpRecord> IpRecords => Set<IpRecord>();

    public DbSet<OutboxMessage> OutboxMessages => Set<OutboxMessage>();

    public DbSet<PushDeviceRegistration> PushDeviceRegistrations => Set<PushDeviceRegistration>();

    public DbSet<UserPublicIpSnapshot> UserPublicIpSnapshots => Set<UserPublicIpSnapshot>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());
    }
}
