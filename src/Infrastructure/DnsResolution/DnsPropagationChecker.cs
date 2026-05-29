using System.Net;
using DnsClient;
using DnsClient.Protocol;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Dns;
using AppDnsRecordType = Ntk.Note.IP.Application.Dns.DnsRecordType;

namespace Ntk.Note.IP.Infrastructure.DnsResolution;

public sealed class DnsPropagationChecker : IDnsPropagationChecker
{
    private static readonly (string Name, IPAddress Server)[] Resolvers =
    [
        ("Google", IPAddress.Parse("8.8.8.8")),
        ("Cloudflare", IPAddress.Parse("1.1.1.1")),
        ("Quad9", IPAddress.Parse("9.9.9.9"))
    ];

    public async Task<DnsPropagationResultDto> CheckAsync(
        string normalizedDomain,
        AppDnsRecordType recordType,
        CancellationToken cancellationToken = default)
    {
        var queryType = MapQueryType(recordType)
                        ?? throw new NotSupportedException($"Record type {recordType} is not supported for propagation check.");

        var resolverResults = new List<DnsPropagationResolverDto>();
        IReadOnlyList<string>? reference = null;

        foreach (var (name, server) in Resolvers)
        {
            cancellationToken.ThrowIfCancellationRequested();

            var client = new LookupClient(server);
            var response = await client.QueryAsync(normalizedDomain, queryType, cancellationToken: cancellationToken);
            var values = ExtractValues(recordType, response);
            reference ??= values;

            resolverResults.Add(new DnsPropagationResolverDto
            {
                ResolverName = name,
                Values = values,
                MatchesReference = ValuesEqual(reference, values)
            });
        }

        return new DnsPropagationResultDto
        {
            Domain = normalizedDomain,
            RecordType = recordType.ToString().ToUpperInvariant(),
            Resolvers = resolverResults
        };
    }

    private static QueryType? MapQueryType(AppDnsRecordType type) => type switch
    {
        AppDnsRecordType.A => QueryType.A,
        AppDnsRecordType.Aaaa => QueryType.AAAA,
        AppDnsRecordType.Mx => QueryType.MX,
        AppDnsRecordType.Txt => QueryType.TXT,
        AppDnsRecordType.Ns => QueryType.NS,
        AppDnsRecordType.Cname => QueryType.CNAME,
        _ => null
    };

    private static IReadOnlyList<string> ExtractValues(AppDnsRecordType type, IDnsQueryResponse response)
    {
        var values = new List<string>();
        foreach (var answer in response.Answers)
        {
            switch (answer)
            {
                case ARecord a:
                    values.Add(a.Address.ToString());
                    break;
                case AaaaRecord aaaa:
                    values.Add(aaaa.Address.ToString());
                    break;
                case MxRecord mx:
                    values.Add($"{mx.Preference} {mx.Exchange.Value.TrimEnd('.')}");
                    break;
                case TxtRecord txt:
                    values.Add(string.Join(string.Empty, txt.Text));
                    break;
                case NsRecord ns:
                    values.Add(ns.NSDName.Value.TrimEnd('.'));
                    break;
                case CNameRecord cname:
                    values.Add(cname.CanonicalName.Value.TrimEnd('.'));
                    break;
            }
        }

        return values.OrderBy(v => v, StringComparer.OrdinalIgnoreCase).ToList();
    }

    private static bool ValuesEqual(IReadOnlyList<string> left, IReadOnlyList<string> right) =>
        left.SequenceEqual(right, StringComparer.OrdinalIgnoreCase);
}
