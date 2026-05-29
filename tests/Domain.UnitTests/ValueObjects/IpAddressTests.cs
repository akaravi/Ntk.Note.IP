using System.Net.Sockets;
using Ntk.Note.IP.Domain.Enums;
using Ntk.Note.IP.Domain.Exceptions;
using Ntk.Note.IP.Domain.ValueObjects;
using NUnit.Framework;
using Shouldly;

namespace Ntk.Note.IP.Domain.UnitTests.ValueObjects;

public class IpAddressTests
{
    [Test]
    public void ParseShouldNormalizeIpv4()
    {
        var address = IpAddress.Parse("8.8.8.8");

        address.Value.ShouldBe("8.8.8.8");
        address.IsIPv4.ShouldBeTrue();
        address.GetScope().ShouldBe(IpAddressScope.Public);
    }

    [Test]
    public void ParseShouldDetectLoopback()
    {
        IpAddress.Parse("127.0.0.1").GetScope().ShouldBe(IpAddressScope.Loopback);
    }

    [Test]
    public void ParseShouldDetectPrivateRange()
    {
        IpAddress.Parse("10.0.0.1").GetScope().ShouldBe(IpAddressScope.Private);
        IpAddress.Parse("192.168.1.1").GetScope().ShouldBe(IpAddressScope.Private);
    }

    [Test]
    public void TryParseShouldRejectInvalidInput()
    {
        IpAddress.TryParse("not-an-ip", out var address).ShouldBeFalse();
        address.ShouldBeNull();
    }

    [Test]
    public void ParseShouldThrowForInvalidInput()
    {
        Should.Throw<InvalidIpAddressException>(() => IpAddress.Parse("999.999.999.999"));
    }

    [Test]
    public void ToUInt32AndFromUInt32ShouldRoundTrip()
    {
        var original = IpAddress.Parse("203.0.113.25");
        var value = original.ToUInt32();
        value.ShouldNotBeNull();

        var restored = IpAddress.FromUInt32(value!.Value);
        restored!.Value.ShouldBe(original.Value);
    }

    [Test]
    public void EqualityShouldCompareNormalizedValue()
    {
        var a = IpAddress.Parse("8.8.4.4");
        var b = IpAddress.Parse("8.8.4.4");

        a.ShouldBe(b);
    }

    [Test]
    public void ParseShouldSupportIpv6()
    {
        var address = IpAddress.Parse("2001:4860:4860::8888");

        address.IsIPv6.ShouldBeTrue();
        address.Family.ShouldBe(AddressFamily.InterNetworkV6);
    }

    [Test]
    public void ParseShouldDetectCgnatRange()
    {
        IpAddress.Parse("100.64.0.1").GetScope().ShouldBe(IpAddressScope.Cgnat);
        IpAddress.Parse("100.127.255.254").GetScope().ShouldBe(IpAddressScope.Cgnat);
    }

    [Test]
    public void ParseShouldDetectLinkLocalIpv4()
    {
        IpAddress.Parse("169.254.10.20").GetScope().ShouldBe(IpAddressScope.LinkLocal);
    }

    [Test]
    public void ParseShouldDetectUniqueLocalIpv6()
    {
        IpAddress.Parse("fd12::1").GetScope().ShouldBe(IpAddressScope.UniqueLocal);
    }

    [Test]
    public void ParseShouldDetectFullPrivateRanges()
    {
        IpAddress.Parse("172.16.0.1").GetScope().ShouldBe(IpAddressScope.Private);
        IpAddress.Parse("172.31.255.255").GetScope().ShouldBe(IpAddressScope.Private);
    }

    [Test]
    public void TryParseShouldRejectEmptyAndWhitespace()
    {
        IpAddress.TryParse("", out _).ShouldBeFalse();
        IpAddress.TryParse("   ", out _).ShouldBeFalse();
    }
}
