using Ntk.Note.IP.Application.IpTools;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IPortCheckService
{
    Task<PortCheckResultDto> CheckAsync(string host, int port, CancellationToken cancellationToken = default);
}
