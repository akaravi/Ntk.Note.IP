using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Dns;
using AppDnsRecordType = Ntk.Note.IP.Application.Dns.DnsRecordType;

namespace Ntk.Note.IP.Infrastructure.DnsResolution;

public sealed class FakeDnsResolutionService : IDnsResolutionService
{
    public Task<DnsResolveResultDto> ResolveAsync(
        string normalizedDomain,
        IReadOnlyCollection<AppDnsRecordType> recordTypes,
        CancellationToken cancellationToken = default)
    {
        var records = new List<DnsRecordDto>();

        if (recordTypes.Contains(AppDnsRecordType.A))
        {
            records.Add(new DnsRecordDto { Type = "A", Name = normalizedDomain, Value = "93.184.216.34", Ttl = 300 });
        }

        if (recordTypes.Contains(AppDnsRecordType.Aaaa))
        {
            records.Add(new DnsRecordDto
            {
                Type = "AAAA",
                Name = normalizedDomain,
                Value = "2606:2800:220:1:248:1893:25c8:1946",
                Ttl = 300
            });
        }

        if (recordTypes.Contains(AppDnsRecordType.Mx))
        {
            records.Add(new DnsRecordDto
            {
                Type = "MX",
                Name = normalizedDomain,
                Value = "mail.example.com",
                Preference = 10,
                Ttl = 3600
            });
        }

        if (recordTypes.Contains(AppDnsRecordType.Txt))
        {
            records.Add(new DnsRecordDto
            {
                Type = "TXT",
                Name = normalizedDomain,
                Value = "v=spf1 include:_spf.example.com ~all",
                Ttl = 3600
            });
        }

        if (recordTypes.Contains(AppDnsRecordType.Ns))
        {
            records.Add(new DnsRecordDto
            {
                Type = "NS",
                Name = normalizedDomain,
                Value = "ns1.example.com",
                Ttl = 86400
            });
        }

        if (recordTypes.Contains(AppDnsRecordType.Cname))
        {
            records.Add(new DnsRecordDto
            {
                Type = "CNAME",
                Name = $"www.{normalizedDomain}",
                Value = normalizedDomain,
                Ttl = 300
            });
        }

        return Task.FromResult(new DnsResolveResultDto
        {
            Domain = normalizedDomain,
            Records = records
        });
    }
}
