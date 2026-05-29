using Ntk.Note.IP.Application.IpLookup;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.IpLookup;

public class IpLookupMapperTests
{
    [TestCase("AS15169 Google LLC", "15169", "Google LLC")]
    [TestCase("AS44244 Iran Cell", "44244", "Iran Cell")]
    public void ShouldParseAsnString(string raw, string number, string organization)
    {
        var asn = IpLookupMapper.ParseAsn(raw);
        asn.Number.ShouldBe(number);
        asn.Organization.ShouldBe(organization);
    }
}
