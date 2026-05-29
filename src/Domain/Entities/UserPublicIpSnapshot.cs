namespace Ntk.Note.IP.Domain.Entities;

/// <summary>
/// Last known public IP for a user (server-side change detection for push).
/// </summary>
public class UserPublicIpSnapshot : BaseEntity
{
    public string UserId { get; set; } = string.Empty;

    public string Address { get; set; } = string.Empty;

    public DateTimeOffset UpdatedAt { get; set; }
}
