using Ntk.Note.IP.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Ntk.Note.IP.Infrastructure.Data.Configurations;

public class IpRecordConfiguration : IEntityTypeConfiguration<IpRecord>
{
    public void Configure(EntityTypeBuilder<IpRecord> builder)
    {
        builder.Property(r => r.Address)
            .HasMaxLength(45)
            .IsRequired();

        builder.Property(r => r.UserId)
            .HasMaxLength(450);

        builder.Property(r => r.Note)
            .HasMaxLength(2000);

        builder.Property(r => r.Tags)
            .HasMaxLength(500);

        builder.Property(r => r.CountryCode)
            .HasMaxLength(2);

        builder.Property(r => r.City)
            .HasMaxLength(128);

        builder.Property(r => r.UserAgent)
            .HasMaxLength(512);

        builder.HasIndex(r => r.Address);
        builder.HasIndex(r => r.UserId);
        builder.HasIndex(r => new { r.UserId, r.Created });
        builder.HasQueryFilter(r => !r.IsSoftDeleted);
    }
}
