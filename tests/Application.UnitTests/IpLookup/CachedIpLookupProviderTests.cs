using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.Options;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Options;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Infrastructure.Caching;
using Ntk.Note.IP.Infrastructure.IpLookup;
using Moq;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.IpLookup;

public class CachedIpLookupProviderTests
{
    [Test]
    public async Task ShouldCacheSecondLookup()
    {
        var inner = new Mock<IIpLookupProvider>();
        inner.Setup(p => p.LookupAsync("1.1.1.1", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new IpLookupResultDto { Address = "1.1.1.1", Country = "AU" });

        var cacheService = new TwoTierCacheService(
            new MemoryCache(new MemoryCacheOptions()),
            Options.Create(new CacheOptions { IpLookupMinutes = 10 }),
            distributedCache: null);
        var cached = new CachedIpLookupProvider(
            inner.Object,
            cacheService,
            Options.Create(new CacheOptions { IpLookupMinutes = 10 }));

        await cached.LookupAsync("1.1.1.1");
        await cached.LookupAsync("1.1.1.1");

        inner.Verify(p => p.LookupAsync("1.1.1.1", It.IsAny<CancellationToken>()), Times.Once);
    }
}
