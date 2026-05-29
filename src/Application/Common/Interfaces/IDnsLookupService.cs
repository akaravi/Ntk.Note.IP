namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IDnsLookupService
{
    Task<string?> GetReverseDnsAsync(string normalizedAddress, CancellationToken cancellationToken = default);
}
