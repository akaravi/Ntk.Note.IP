using Ntk.Note.IP.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Ntk.Note.IP.Infrastructure.Data.Configurations;

public class IpNoteConfiguration : IEntityTypeConfiguration<IpNote>
{
    public void Configure(EntityTypeBuilder<IpNote> builder)
    {
        builder.Property(n => n.Address)
            .HasMaxLength(45)
            .IsRequired();

        builder.Property(n => n.Title)
            .HasMaxLength(200);

        builder.Property(n => n.Body)
            .HasMaxLength(8000);

        builder.Property(n => n.Tags)
            .HasMaxLength(500);

        builder.Property(n => n.ClientTimezone)
            .HasMaxLength(100);

        builder.Property(n => n.LocalIpAddress)
            .HasMaxLength(45);

        builder.Property(n => n.CountryCode)
            .HasMaxLength(8);

        builder.Property(n => n.Region)
            .HasMaxLength(120);

        builder.Property(n => n.City)
            .HasMaxLength(120);

        builder.Property(n => n.Isp)
            .HasMaxLength(256);

        builder.Property(n => n.Asn)
            .HasMaxLength(256);

        builder.Property(n => n.DeviceLabel)
            .HasMaxLength(200);

        builder.HasIndex(n => n.Address);
        builder.HasIndex(n => n.CreatedBy);
        builder.HasIndex(n => new { n.CreatedBy, n.Created });
        builder.HasIndex(n => new { n.Created, n.Id });
        builder.HasQueryFilter(n => !n.IsSoftDeleted);
    }
}
