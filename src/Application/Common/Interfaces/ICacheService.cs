namespace Ntk.Note.IP.Application.Common.Interfaces;

public interface ICacheService
{
    Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default)
        where T : class;

    Task SetAsync<T>(
        string key,
        T value,
        TimeSpan absoluteExpiration,
        CancellationToken cancellationToken = default)
        where T : class;
}
