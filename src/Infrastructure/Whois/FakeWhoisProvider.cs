using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Whois;

namespace Ntk.Note.IP.Infrastructure.Whois;

public sealed class FakeWhoisProvider : IWhoisProvider
{
    public Task<WhoisIpDto> LookupIpAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        return Task.FromResult(new WhoisIpDto
        {
            Address = normalizedAddress,
            Handle = "FAKE-EXAMPLE",
            Name = "Example Organization",
            Country = "IR",
            StartAddress = normalizedAddress,
            EndAddress = normalizedAddress,
            Type = "ASSIGNED PA",
            RegistrationDate = DateTimeOffset.Parse("2010-01-01T00:00:00Z"),
            RawPayload = "{\"provider\":\"Fake\"}"
        });
    }

    public Task<WhoisDomainDto> LookupDomainAsync(string normalizedDomain, CancellationToken cancellationToken = default)
    {
        return Task.FromResult(new WhoisDomainDto
        {
            Domain = normalizedDomain,
            Handle = "FAKE-DOMAIN",
            Name = normalizedDomain,
            NameServers = ["ns1.example.com", "ns2.example.com"],
            Status = "active",
            RegistrationDate = DateTimeOffset.Parse("2015-06-01T00:00:00Z"),
            ExpirationDate = DateTimeOffset.Parse("2026-06-01T00:00:00Z"),
            RawPayload = "{\"provider\":\"Fake\"}"
        });
    }
}
