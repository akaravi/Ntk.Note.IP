namespace Ntk.Note.IP.Application.Admin;

public class AdminRoleDto
{
    public string Id { get; init; } = string.Empty;

    public string Name { get; init; } = string.Empty;

    public int UserCount { get; init; }

    public IReadOnlyList<string> Permissions { get; init; } = [];

    public bool IsSystem { get; init; }
}
