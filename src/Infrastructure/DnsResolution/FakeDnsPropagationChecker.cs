using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Dns;
using AppDnsRecordType = Ntk.Note.IP.Application.Dns.DnsRecordType;

namespace Ntk.Note.IP.Infrastructure.DnsResolution;

public sealed class FakeDnsPropagationChecker : IDnsPropagationChecker
{
    public Task<DnsPropagationResultDto> CheckAsync(
        string normalizedDomain,
        AppDnsRecordType recordType,
        CancellationToken cancellationToken = default)
    {
        var values = new[] { "93.184.216.34" };
        IReadOnlyList<DnsPropagationResolverDto> resolvers =
        [
            new() { ResolverName = "Google", Values = values, MatchesReference = true },
            new() { ResolverName = "Cloudflare", Values = values, MatchesReference = true },
            new() { ResolverName = "Quad9", Values = ["93.184.216.35"], MatchesReference = false }
        ];

        return Task.FromResult(new DnsPropagationResultDto
        {
            Domain = normalizedDomain,
            RecordType = recordType.ToString().ToUpperInvariant(),
            Resolvers = resolvers
        });
    }
}
