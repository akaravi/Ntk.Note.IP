namespace Ntk.Note.IP.Application.Admin;

public class AdminAccessDto
{
    public bool IsAdministrator { get; init; }

    public IReadOnlyList<string> Roles { get; init; } = [];
}
