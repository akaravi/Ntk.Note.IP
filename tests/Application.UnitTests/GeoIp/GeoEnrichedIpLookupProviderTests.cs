using Microsoft.Extensions.Logging;
using Moq;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.GeoIp;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Infrastructure.GeoIp;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.GeoIp;

public class GeoEnrichedIpLookupProviderTests
{
    [Test]
    public async Task ShouldFillMissingGeoFromOfflineDatabase()
    {
        var inner = new Mock<IIpLookupProvider>();
        inner.Setup(p => p.LookupAsync("8.8.8.8", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new IpLookupResultDto { Address = "8.8.8.8" });

        var geoDb = new Mock<IGeoIpDatabase>();
        geoDb.Setup(g => g.TryLookupAsync("8.8.8.8", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new GeoIpLookupResult
            {
                Address = "8.8.8.8",
                CountryCode = "US",
                Country = "United States",
                City = "Mountain View"
            });

        var provider = CreateProvider(inner.Object, geoDb.Object);
        var result = await provider.LookupAsync("8.8.8.8");

        result.CountryCode.ShouldBe("US");
        result.City.ShouldBe("Mountain View");
    }

    [Test]
    public async Task ShouldUseOfflineGeoWhenOnlineProviderFails()
    {
        var inner = new Mock<IIpLookupProvider>();
        inner.Setup(p => p.LookupAsync("95.38.10.25", It.IsAny<CancellationToken>()))
            .ThrowsAsync(new InvalidOperationException("provider down"));

        var geoDb = new Mock<IGeoIpDatabase>();
        geoDb.Setup(g => g.TryLookupAsync("95.38.10.25", It.IsAny<CancellationToken>()))
            .ReturnsAsync(new GeoIpLookupResult
            {
                Address = "95.38.10.25",
                CountryCode = "IR",
                Country = "Iran",
                City = "Tehran"
            });

        var provider = CreateProvider(inner.Object, geoDb.Object);
        var result = await provider.LookupAsync("95.38.10.25");

        result.Address.ShouldBe("95.38.10.25");
        result.CountryCode.ShouldBe("IR");
        result.City.ShouldBe("Tehran");
    }

    private static GeoEnrichedIpLookupProvider CreateProvider(
        IIpLookupProvider inner,
        IGeoIpDatabase geoDb) =>
        new(
            inner,
            geoDb,
            Mock.Of<ILogger<GeoEnrichedIpLookupProvider>>());
}
