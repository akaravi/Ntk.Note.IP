namespace Ntk.Note.IP.Application.Whois;

public class WhoisDomainDto
{
    public string Domain { get; init; } = string.Empty;

    public string? Handle { get; init; }

    public string? Name { get; init; }

    public string[] NameServers { get; init; } = [];

    public string? Status { get; init; }

    public DateTimeOffset? RegistrationDate { get; init; }

    public DateTimeOffset? ExpirationDate { get; init; }

    public string? RawPayload { get; init; }
}
