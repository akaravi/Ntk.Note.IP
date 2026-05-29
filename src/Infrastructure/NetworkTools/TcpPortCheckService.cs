using System.Diagnostics;
using System.Net.Sockets;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.IpTools;

namespace Ntk.Note.IP.Infrastructure.NetworkTools;

public sealed class TcpPortCheckService : IPortCheckService
{
    public async Task<PortCheckResultDto> CheckAsync(string host, int port, CancellationToken cancellationToken = default)
    {
        using var client = new TcpClient();
        var stopwatch = Stopwatch.StartNew();

        try
        {
            await client.ConnectAsync(host, port, cancellationToken);
            stopwatch.Stop();

            return new PortCheckResultDto
            {
                Host = host,
                Port = port,
                IsOpen = true,
                LatencyMs = (int)stopwatch.ElapsedMilliseconds
            };
        }
        catch (Exception ex)
        {
            stopwatch.Stop();
            return new PortCheckResultDto
            {
                Host = host,
                Port = port,
                IsOpen = false,
                LatencyMs = (int)stopwatch.ElapsedMilliseconds,
                ErrorMessage = ex.Message
            };
        }
    }
}
