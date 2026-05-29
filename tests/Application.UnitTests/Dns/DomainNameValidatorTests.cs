using Ntk.Note.IP.Application.Dns;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Application.UnitTests.Dns;

public class DomainNameValidatorTests
{
    [TestCase("example.com", true)]
    [TestCase("sub.example.co.uk", true)]
    [TestCase("not valid", false)]
    [TestCase("", false)]
    public void ShouldValidateDomainNames(string input, bool expected)
    {
        var ok = DomainNameValidator.TryNormalize(input, out var normalized);
        ok.ShouldBe(expected);
        if (expected)
        {
            normalized.ShouldNotBeNullOrWhiteSpace();
        }
    }
}
