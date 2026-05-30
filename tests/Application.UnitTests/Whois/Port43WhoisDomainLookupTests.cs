using Ntk.Note.IP.Infrastructure.Whois;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.Whois;

public class Port43WhoisDomainLookupTests
{
    [Test]
    public void ShouldParseIrnicWhoisText()
    {
        const string raw = """
            domain:  example.ir
            status:  active
            holder:  hld-12345
            nserver: ns1.example.ir
            nserver: ns2.example.ir
            created: 2019-05-10 12:00:00
            expire-date: 2026-05-10 12:00:00
            """;

        var result = Port43WhoisDomainLookup.Parse(raw, "example.ir");

        result.Domain.ShouldBe("example.ir");
        result.Handle.ShouldBe("hld-12345");
        result.Status.ShouldBe("active");
        result.NameServers.ShouldBe(["ns1.example.ir", "ns2.example.ir"]);
        result.RegistrationDate.ShouldNotBeNull();
        result.ExpirationDate.ShouldNotBeNull();
    }

    [Test]
    public void ShouldParseVerisignWhoisText()
    {
        const string raw = """
            Domain Name: EXAMPLE.COM
            Registry Domain ID: 2336799_DOMAIN_COM-VRSN
            Name Server: NS1.EXAMPLE.COM
            Name Server: NS2.EXAMPLE.COM
            Creation Date: 1995-08-14T04:00:00Z
            Registry Expiry Date: 2026-08-13T04:00:00Z
            Domain Status: clientTransferProhibited
            """;

        var result = Port43WhoisDomainLookup.Parse(raw, "example.com");

        result.Name.ShouldBe("EXAMPLE.COM");
        result.Handle.ShouldBe("2336799_DOMAIN_COM-VRSN");
        result.NameServers.ShouldBe(["NS1.EXAMPLE.COM", "NS2.EXAMPLE.COM"]);
        result.Status.ShouldNotBeNull();
        result.Status.ShouldContain("clientTransferProhibited");
    }
}
