using DnsClient;
using DnsClient.Protocol;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Dns;
using AppDnsRecordType = Ntk.Note.IP.Application.Dns.DnsRecordType;

namespace Ntk.Note.IP.Infrastructure.DnsResolution;

public sealed class DnsClientResolutionService : IDnsResolutionService
{
    private readonly LookupClient _client = new();

    public async Task<DnsResolveResultDto> ResolveAsync(
        string normalizedDomain,
        IReadOnlyCollection<AppDnsRecordType> recordTypes,
        CancellationToken cancellationToken = default)
    {
        var records = new List<DnsRecordDto>();

        foreach (var recordType in recordTypes.Distinct())
        {
            cancellationToken.ThrowIfCancellationRequested();

            var queryType = MapQueryType(recordType);
            if (queryType is null)
            {
                continue;
            }

            var response = await _client.QueryAsync(normalizedDomain, queryType.Value, cancellationToken: cancellationToken);
            records.AddRange(MapAnswers(normalizedDomain, recordType, response));
        }

        return new DnsResolveResultDto
        {
            Domain = normalizedDomain,
            Records = records
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
        AppDnsRecordType.Soa => QueryType.SOA,
        _ => null
    };

    private static IEnumerable<DnsRecordDto> MapAnswers(
        string domain,
        AppDnsRecordType type,
        IDnsQueryResponse response)
    {
        foreach (var answer in response.Answers)
        {
            var dto = MapRecord(domain, type, answer);
            if (dto is not null)
            {
                yield return dto;
            }
        }
    }

    private static DnsRecordDto? MapRecord(string domain, AppDnsRecordType type, DnsResourceRecord answer)
    {
        var ttl = (int?)answer.InitialTimeToLive;
        var name = answer.DomainName.Value.TrimEnd('.');

        return answer switch
        {
            ARecord a => new DnsRecordDto
            {
                Type = type.ToString().ToUpperInvariant(),
                Name = name,
                Value = a.Address.ToString(),
                Ttl = ttl
            },
            AaaaRecord aaaa => new DnsRecordDto
            {
                Type = type.ToString().ToUpperInvariant(),
                Name = name,
                Value = aaaa.Address.ToString(),
                Ttl = ttl
            },
            MxRecord mx => new DnsRecordDto
            {
                Type = "MX",
                Name = name,
                Value = mx.Exchange.Value.TrimEnd('.'),
                Preference = mx.Preference,
                Ttl = ttl
            },
            TxtRecord txt => new DnsRecordDto
            {
                Type = "TXT",
                Name = name,
                Value = string.Join(string.Empty, txt.Text),
                Ttl = ttl
            },
            NsRecord ns => new DnsRecordDto
            {
                Type = "NS",
                Name = name,
                Value = ns.NSDName.Value.TrimEnd('.'),
                Ttl = ttl
            },
            CNameRecord cname => new DnsRecordDto
            {
                Type = "CNAME",
                Name = name,
                Value = cname.CanonicalName.Value.TrimEnd('.'),
                Ttl = ttl
            },
            SoaRecord soa => new DnsRecordDto
            {
                Type = "SOA",
                Name = name,
                Value = $"{soa.MName.Value.TrimEnd('.')} {soa.RName.Value}",
                Ttl = ttl
            },
            _ => null
        };
    }
}
