namespace Ntk.Note.IP.Web.Infrastructure;

/// <summary>
/// Central API route prefixes for Minimal API endpoint groups.
/// </summary>
public static class ApiRoutes
{
    public const string VersionPrefix = "/api/v1";

    public static string Group(string groupName) => $"{VersionPrefix}/{groupName}";
}
