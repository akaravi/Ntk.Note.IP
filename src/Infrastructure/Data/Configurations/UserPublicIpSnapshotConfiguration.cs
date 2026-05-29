using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Infrastructure.Data.Configurations;

public class UserPublicIpSnapshotConfiguration : IEntityTypeConfiguration<UserPublicIpSnapshot>
{
    public void Configure(EntityTypeBuilder<UserPublicIpSnapshot> builder)
    {
        builder.Property(s => s.UserId)
            .HasMaxLength(450)
            .IsRequired();

        builder.Property(s => s.Address)
            .HasMaxLength(45)
            .IsRequired();

        builder.HasIndex(s => s.UserId)
            .IsUnique();
    }
}
