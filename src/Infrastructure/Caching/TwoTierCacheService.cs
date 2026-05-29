using System.Text.Json;
using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;

namespace Ntk.Note.IP.Infrastructure.Caching;

public sealed class TwoTierCacheService(
    IMemoryCache memoryCache,
    IOptions<CacheOptions> options,
    IDistributedCache? distributedCache = null) : ICacheService
{
    private static readonly JsonSerializerOptions JsonOptions = new(JsonSerializerDefaults.Web);

    public async Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default)
        where T : class
    {
        if (memoryCache.TryGetValue(key, out T? cached) && cached is not null)
        {
            return cached;
        }

        if (distributedCache is null)
        {
            return null;
        }

        var bytes = await distributedCache.GetAsync(PrefixedKey(key), cancellationToken);
        if (bytes is null || bytes.Length == 0)
        {
            return null;
        }

        var value = JsonSerializer.Deserialize<T>(bytes, JsonOptions);
        if (value is not null)
        {
            memoryCache.Set(key, value, TimeSpan.FromMinutes(1));
        }

        return value;
    }

    public async Task SetAsync<T>(
        string key,
        T value,
        TimeSpan absoluteExpiration,
        CancellationToken cancellationToken = default)
        where T : class
    {
        memoryCache.Set(key, value, absoluteExpiration);

        if (distributedCache is null)
        {
            return;
        }

        var bytes = JsonSerializer.SerializeToUtf8Bytes(value, JsonOptions);
        await distributedCache.SetAsync(
            PrefixedKey(key),
            bytes,
            new DistributedCacheEntryOptions { AbsoluteExpirationRelativeToNow = absoluteExpiration },
            cancellationToken);
    }

    private string PrefixedKey(string key) => $"{options.Value.RedisInstanceName}{key}";
}
