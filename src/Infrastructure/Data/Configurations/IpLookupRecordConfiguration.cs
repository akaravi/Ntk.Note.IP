using Ntk.Note.IP.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Ntk.Note.IP.Infrastructure.Data.Configurations;

public class IpLookupRecordConfiguration : IEntityTypeConfiguration<IpLookupRecord>
{
    public void Configure(EntityTypeBuilder<IpLookupRecord> builder)
    {
        builder.Property(r => r.Address)
            .HasMaxLength(45)
            .IsRequired();

        builder.Property(r => r.CountryCode)
            .HasMaxLength(2);

        builder.Property(r => r.Region)
            .HasMaxLength(128);

        builder.Property(r => r.City)
            .HasMaxLength(128);

        builder.Property(r => r.Asn)
            .HasMaxLength(32);

        builder.Property(r => r.Isp)
            .HasMaxLength(256);

        builder.HasIndex(r => r.Address);
        builder.HasIndex(r => r.Created);
    }
}
