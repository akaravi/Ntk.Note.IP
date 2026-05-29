namespace Ntk.Note.IP.Application.Blacklist;

public class BlacklistHitDto
{
    public string ListId { get; init; } = string.Empty;

    public string ListName { get; init; } = string.Empty;

    public string ResponseCode { get; init; } = string.Empty;

    public bool IsListed { get; init; }
}
