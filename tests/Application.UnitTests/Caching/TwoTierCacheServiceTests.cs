using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Infrastructure.Caching;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.Caching;

public class TwoTierCacheServiceTests
{
    [Test]
    public async Task ShouldStoreAndRetrieveFromMemoryTier()
    {
        var cache = new TwoTierCacheService(
            new MemoryCache(new MemoryCacheOptions()),
            Options.Create(new CacheOptions()),
            distributedCache: null);

        await cache.SetAsync("k1", new SamplePayload { Value = "cached" }, TimeSpan.FromMinutes(5));
        var result = await cache.GetAsync<SamplePayload>("k1");

        result.ShouldNotBeNull();
        result!.Value.ShouldBe("cached");
    }

    private sealed class SamplePayload
    {
        public string Value { get; init; } = string.Empty;
    }
}
