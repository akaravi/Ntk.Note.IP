using Ntk.Note.IP.Application.Blacklist;

namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface IBlacklistChecker
{
    Task<IReadOnlyList<BlacklistHitDto>> CheckAsync(string normalizedAddress, CancellationToken cancellationToken = default);
}
