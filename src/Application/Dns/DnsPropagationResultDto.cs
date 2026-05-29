namespace Ntk.Note.IP.Application.Dns;

public class DnsPropagationResultDto
{
    public string Domain { get; init; } = string.Empty;

    public string RecordType { get; init; } = string.Empty;

    public IReadOnlyList<DnsPropagationResolverDto> Resolvers { get; init; } = [];
}

public class DnsPropagationResolverDto
{
    public string ResolverName { get; init; } = string.Empty;

    public IReadOnlyList<string> Values { get; init; } = [];

    public bool MatchesReference { get; init; }
}
