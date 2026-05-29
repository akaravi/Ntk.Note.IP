using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Application.IpLookup;

namespace Ntk.Note.IP.Infrastructure.IpLookup;

public sealed class CachedIpLookupProvider(
    IIpLookupProvider inner,
    ICacheService cache,
    IOptions<CacheOptions> options) : IIpLookupProvider
{
    public async Task<IpLookupResultDto> LookupAsync(string normalizedAddress, CancellationToken cancellationToken = default)
    {
        var cacheKey = $"iplookup:{normalizedAddress}";
        var cached = await cache.GetAsync<IpLookupResultDto>(cacheKey, cancellationToken);
        if (cached is not null)
        {
            return cached;
        }

        var result = await inner.LookupAsync(normalizedAddress, cancellationToken);
        await cache.SetAsync(
            cacheKey,
            result,
            TimeSpan.FromMinutes(Math.Max(1, options.Value.IpLookupMinutes)),
            cancellationToken);
        return result;
    }
}
