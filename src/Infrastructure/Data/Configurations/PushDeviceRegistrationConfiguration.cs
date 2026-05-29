using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Infrastructure.Data.Configurations;

public class PushDeviceRegistrationConfiguration : IEntityTypeConfiguration<PushDeviceRegistration>
{
    public void Configure(EntityTypeBuilder<PushDeviceRegistration> builder)
    {
        builder.Property(p => p.DeviceToken)
            .HasMaxLength(512)
            .IsRequired();

        builder.Property(p => p.Platform)
            .HasMaxLength(16)
            .IsRequired();

        builder.HasIndex(p => new { p.CreatedBy, p.DeviceToken })
            .IsUnique();
    }
}
