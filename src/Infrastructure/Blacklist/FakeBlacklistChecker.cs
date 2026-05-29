using Ntk.Note.IP.Application.Blacklist;
using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Infrastructure.Blacklist;

public sealed class FakeBlacklistChecker : IBlacklistChecker
{
    public Task<IReadOnlyList<BlacklistHitDto>> CheckAsync(
        string normalizedAddress,
        CancellationToken cancellationToken = default)
    {
        IReadOnlyList<BlacklistHitDto> hits =
        [
            new()
            {
                ListId = "zen.spamhaus.org",
                ListName = "Spamhaus ZEN",
                ResponseCode = "127.0.0.10",
                IsListed = normalizedAddress.StartsWith("203.0.113", StringComparison.Ordinal)
            },
            new()
            {
                ListId = "bl.spamcop.net",
                ListName = "SpamCop",
                ResponseCode = "NXDOMAIN",
                IsListed = false
            }
        ];

        return Task.FromResult(hits);
    }
}
