using System.Globalization;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using Ntk.Note.IP.Application.Whois;

namespace Ntk.Note.IP.Infrastructure.Whois;

public static partial class Port43WhoisDomainLookup
{
    private static readonly Dictionary<string, string> TldServers =
        new(StringComparer.OrdinalIgnoreCase)
        {
            ["ir"] = "whois.nic.ir",
            ["com"] = "whois.verisign-grs.com",
            ["net"] = "whois.verisign-grs.com",
            ["org"] = "whois.pir.org",
            ["io"] = "whois.nic.io",
            ["info"] = "whois.afilias.net",
            ["biz"] = "whois.biz",
            ["us"] = "whois.nic.us",
            ["uk"] = "whois.nic.uk",
            ["de"] = "whois.denic.de",
            ["fr"] = "whois.nic.fr",
        };

    public static async Task<WhoisDomainDto> LookupAsync(
        string normalizedDomain,
        CancellationToken cancellationToken = default)
    {
        var tld = normalizedDomain.Split('.').LastOrDefault() ?? string.Empty;
        var server = TldServers.GetValueOrDefault(tld) ?? "whois.iana.org";
        var raw = await QueryServerAsync(server, normalizedDomain, cancellationToken);

        if (server.Equals("whois.iana.org", StringComparison.OrdinalIgnoreCase))
        {
            var referServer = ExtractReferServer(raw);
            if (!string.IsNullOrWhiteSpace(referServer))
            {
                raw = await QueryServerAsync(referServer, normalizedDomain, cancellationToken);
            }
        }

        if (string.IsNullOrWhiteSpace(raw) || LooksLikeNotFound(raw))
        {
            throw new InvalidOperationException($"WHOIS data not found for {normalizedDomain}.");
        }

        return Parse(raw, normalizedDomain);
    }

    private static async Task<string> QueryServerAsync(
        string server,
        string domain,
        CancellationToken cancellationToken)
    {
        using var client = new TcpClient();
        using var connectCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        connectCts.CancelAfter(TimeSpan.FromSeconds(12));

        await client.ConnectAsync(server, 43, connectCts.Token);

        await using var stream = client.GetStream();
        stream.ReadTimeout = 12_000;
        stream.WriteTimeout = 12_000;

        var query = Encoding.ASCII.GetBytes($"{domain}\r\n");
        await stream.WriteAsync(query, cancellationToken);

        using var reader = new StreamReader(stream, Encoding.UTF8, detectEncodingFromByteOrderMarks: true);
        using var readCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
        readCts.CancelAfter(TimeSpan.FromSeconds(15));

        try
        {
            return await reader.ReadToEndAsync(readCts.Token);
        }
        catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
        {
            throw new InvalidOperationException($"WHOIS server {server} timed out for {domain}.");
        }
    }

    private static string? ExtractReferServer(string raw)
    {
        foreach (Match match in ReferServerRegex().Matches(raw))
        {
            var candidate = match.Groups[1].Value.Trim().TrimEnd('.');
            if (!string.IsNullOrWhiteSpace(candidate))
            {
                return candidate;
            }
        }

        return null;
    }

    private static bool LooksLikeNotFound(string raw)
    {
        return NotFoundRegex().IsMatch(raw);
    }

    public static WhoisDomainDto Parse(string raw, string normalizedDomain)
    {
        var nameServers = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (Match match in NameServerRegex().Matches(raw))
        {
            var value = match.Groups[1].Value.Trim().TrimEnd('.');
            if (!string.IsNullOrWhiteSpace(value))
            {
                nameServers.Add(value);
            }
        }

        var statusValues = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (Match match in StatusRegex().Matches(raw))
        {
            var value = match.Groups[1].Value.Trim();
            if (!string.IsNullOrWhiteSpace(value))
            {
                statusValues.Add(value);
            }
        }

        var registered = ParseDate(FindFirst(raw, RegistrationDateRegex()));
        var expires = ParseDate(FindFirst(raw, ExpirationDateRegex()));
        var handle = FindFirst(raw, HandleRegex());

        return new WhoisDomainDto
        {
            Domain = normalizedDomain,
            Handle = handle,
            Name = FindFirst(raw, DomainNameRegex()) ?? normalizedDomain,
            NameServers = [..nameServers],
            Status = statusValues.Count == 0 ? null : string.Join(", ", statusValues),
            RegistrationDate = registered,
            ExpirationDate = expires,
            RawPayload = raw,
        };
    }

    private static string? FindFirst(string raw, Regex regex)
    {
        var match = regex.Match(raw);
        return match.Success ? match.Groups[1].Value.Trim() : null;
    }

    private static DateTimeOffset? ParseDate(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        if (DateTimeOffset.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.AssumeUniversal, out var parsed))
        {
            return parsed;
        }

        return null;
    }

    [GeneratedRegex(@"refer:\s*(\S+)", RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex ReferServerRegex();

    [GeneratedRegex(
        @"\b(no\s+match|not\s+found|no\s+entries\s+found|status:\s*free|domain\s+not\s+found|no\s+data\s+found)\b",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex NotFoundRegex();

    [GeneratedRegex(
        @"(?:^|\n)\s*(?:domain\s*name|domain)\s*[:=]\s*(.+)$",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex DomainNameRegex();

    [GeneratedRegex(
        @"(?:^|\n)\s*(?:domain\s*id|registry\s*domain\s*id|handle|holder)\s*[:=]\s*(.+)$",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex HandleRegex();

    [GeneratedRegex(
        @"(?:^|\n)\s*(?:nserver|name\s*server)\s*[:=]\s*(\S+)",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex NameServerRegex();

    [GeneratedRegex(
        @"(?:^|\n)\s*(?:domain\s*status|status)\s*[:=]\s*(.+)$",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex StatusRegex();

    [GeneratedRegex(
        @"(?:^|\n)\s*(?:creation\s*date|created|registration\s*date)\s*[:=]\s*(.+)$",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex RegistrationDateRegex();

    [GeneratedRegex(
        @"(?:^|\n)\s*(?:registry\s*expiry\s*date|expiration\s*date|expire-date|expires|paid-till|renewal\s*date)\s*[:=]\s*(.+)$",
        RegexOptions.IgnoreCase | RegexOptions.Multiline)]
    private static partial Regex ExpirationDateRegex();
}
