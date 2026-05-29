namespace Ntk.Note.IP.Application.Whois;

public class WhoisIpDto
{
    public string Address { get; init; } = string.Empty;

    public string? Handle { get; init; }

    public string? Name { get; init; }

    public string? Country { get; init; }

    public string? StartAddress { get; init; }

    public string? EndAddress { get; init; }

    public string? Type { get; init; }

    public DateTimeOffset? RegistrationDate { get; init; }

    public string? RawPayload { get; init; }
}
