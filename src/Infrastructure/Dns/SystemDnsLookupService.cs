using System.Net;
using System.Net.Sockets;
using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Infrastructure.Dns;

public sealed class SystemDnsLookupService : IDnsLookupService
{
    public async Task<string?> GetReverseDnsAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        if (!IPAddress.TryParse(normalizedAddress, out var ip))
        {
            return null;
        }

        try
        {
            var entry = await System.Net.Dns.GetHostEntryAsync(ip.ToString());
            cancellationToken.ThrowIfCancellationRequested();
            return entry.HostName;
        }
        catch (SocketException)
        {
            return null;
        }
    }
}
