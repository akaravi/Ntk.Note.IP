namespace Ntk.Note.IP.Application.Admin;

public class AdminUserDto
{
    public string Id { get; init; } = string.Empty;

    public string? Email { get; init; }

    public string? UserName { get; init; }

    public bool EmailConfirmed { get; init; }

    public DateTimeOffset? LockoutEnd { get; init; }

    public IReadOnlyList<string> Roles { get; init; } = [];
}
