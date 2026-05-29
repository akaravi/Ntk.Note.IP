using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpLookup;

internal static class IpLookupQueryHelper
{
    public static async Task<(IpAddress Ip, IpLookupResultDto Lookup)> ResolveLookupAsync(
        string address,
        IIpLookupProvider lookupProvider,
        CancellationToken cancellationToken)
    {
        var ip = IpAddress.Parse(address);
        var lookup = await lookupProvider.LookupAsync(ip.Value, cancellationToken);
        return (ip, lookup);
    }
}
