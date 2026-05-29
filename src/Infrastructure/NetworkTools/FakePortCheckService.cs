using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpTools;

namespace Ntk.Note.IP.Infrastructure.NetworkTools;

public sealed class FakePortCheckService : IPortCheckService
{
    public Task<PortCheckResultDto> CheckAsync(string host, int port, CancellationToken cancellationToken = default)
    {
        var open = port is 80 or 443;
        return Task.FromResult(new PortCheckResultDto
        {
            Host = host,
            Port = port,
            IsOpen = open,
            LatencyMs = open ? 12 : null,
            ErrorMessage = open ? null : "Connection refused (fake)"
        });
    }
}
