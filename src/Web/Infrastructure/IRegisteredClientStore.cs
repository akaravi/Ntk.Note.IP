namespace Ntk.Note.IP.Web.Infrastructure;

public interface IRegisteredClientStore
{
    bool TryGet(string clientId, out RegisteredClient client);

    IReadOnlyCollection<RegisteredClient> GetAll();

    IReadOnlyCollection<string> GetAllCorsOrigins();
}
