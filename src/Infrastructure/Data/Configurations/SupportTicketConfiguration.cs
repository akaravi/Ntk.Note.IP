using Ntk.Note.IP.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Ntk.Note.IP.Infrastructure.Data.Configurations;

public class SupportTicketConfiguration : IEntityTypeConfiguration<SupportTicket>
{
    public void Configure(EntityTypeBuilder<SupportTicket> builder)
    {
        builder.Property(t => t.Name)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(t => t.Email)
            .HasMaxLength(256)
            .IsRequired();

        builder.Property(t => t.Subject)
            .HasMaxLength(200)
            .IsRequired();

        builder.Property(t => t.Message)
            .HasMaxLength(4000)
            .IsRequired();

        builder.Property(t => t.EmailError)
            .HasMaxLength(512);

        builder.Property(t => t.UserId)
            .HasMaxLength(450);

        builder.HasIndex(t => t.Status);
        builder.HasIndex(t => t.Created);
        builder.HasIndex(t => t.Email);
    }
}
