namespace Ntk.Note.IP.Application.Common.Interfaces;

/// <summary>
/// Resolves the caller's public IP from the current HTTP request (Forwarded-For or connection).
/// </summary>
public interface IClientIpResolver
{
    string? GetClientIpAddress();
}
