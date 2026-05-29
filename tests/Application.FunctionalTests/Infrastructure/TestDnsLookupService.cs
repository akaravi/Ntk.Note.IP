using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Application.FunctionalTests.Infrastructure;

public sealed class TestDnsLookupService : IDnsLookupService
{
    public Task<string?> GetReverseDnsAsync(string normalizedAddress, CancellationToken cancellationToken = default) =>
        Task.FromResult<string?>("test.example.local");
}
