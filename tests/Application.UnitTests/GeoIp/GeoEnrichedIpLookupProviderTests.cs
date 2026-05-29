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

        var provider = new GeoEnrichedIpLookupProvider(inner.Object, geoDb.Object);
        var result = await provider.LookupAsync("8.8.8.8");

        result.CountryCode.ShouldBe("US");
        result.City.ShouldBe("Mountain View");
    }
}
