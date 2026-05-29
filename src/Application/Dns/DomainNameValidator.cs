namespace Ntk.Note.IP.Application.Dns;

public static class DomainNameValidator
{
    public static bool TryNormalize(string? input, out string normalized)
    {
        normalized = string.Empty;
        if (string.IsNullOrWhiteSpace(input))
        {
            return false;
        }

        var host = input.Trim().TrimEnd('.');
        if (host.Length is 0 or > 253)
        {
            return false;
        }

        var hostType = Uri.CheckHostName(host);
        if (hostType is UriHostNameType.Unknown or UriHostNameType.Basic)
        {
            return false;
        }

        normalized = host.ToLowerInvariant();
        return true;
    }
}
