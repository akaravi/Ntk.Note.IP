using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

public sealed class TestClientIpResolver : IClientIpResolver
{
    public TestClientIpResolver(string address) => _address = address;

    private string _address;

    public void SetAddress(string address) => _address = address;

    public string? GetClientIpAddress() => _address;
}
