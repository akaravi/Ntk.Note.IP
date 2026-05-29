using Ntk.Note.IP.Application.Whois;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IWhoisProvider
{
    Task<WhoisIpDto> LookupIpAsync(string normalizedAddress, CancellationToken cancellationToken = default);

    Task<WhoisDomainDto> LookupDomainAsync(string normalizedDomain, CancellationToken cancellationToken = default);
}
