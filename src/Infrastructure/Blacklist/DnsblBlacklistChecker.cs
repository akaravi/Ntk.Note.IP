using DnsClient;
using Ntk.Note.IP.Application.Blacklist;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Infrastructure.Blacklist;

public sealed class DnsblBlacklistChecker : IBlacklistChecker
{
    private static readonly (string Zone, string Name)[] Lists =
    [
        ("zen.spamhaus.org", "Spamhaus ZEN"),
        ("bl.spamcop.net", "SpamCop"),
        ("dnsbl.sorbs.net", "SORBS")
    ];

    private readonly LookupClient _client = new();

    public async Task<IReadOnlyList<BlacklistHitDto>> CheckAsync(
        string normalizedAddress,
        CancellationToken cancellationToken = default)
    {
        if (!IpAddress.TryParse(normalizedAddress, out var ip) || ip is null || !ip.IsIPv4)
        {
            throw new InvalidOperationException("DNSBL checks require a valid IPv4 address.");
        }

        var reversed = ReverseIpv4(normalizedAddress);
        var results = new List<BlacklistHitDto>();

        foreach (var (zone, name) in Lists)
        {
            cancellationToken.ThrowIfCancellationRequested();
            var queryHost = $"{reversed}.{zone}";

            var response = await _client.QueryAsync(queryHost, QueryType.A, cancellationToken: cancellationToken);
            var record = response.Answers.AddressRecords().FirstOrDefault();
            var listed = record is not null;
            results.Add(new BlacklistHitDto
            {
                ListId = zone,
                ListName = name,
                ResponseCode = listed ? record!.Address.ToString() : "NXDOMAIN",
                IsListed = listed
            });
        }

        return results;
    }

    private static string ReverseIpv4(string address)
    {
        var parts = address.Split('.');
        if (parts.Length != 4)
        {
            throw new ArgumentException("Invalid IPv4 address.", nameof(address));
        }

        return string.Join('.', parts.Reverse());
    }
}
