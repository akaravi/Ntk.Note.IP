using Ntk.Note.IP.Application.Common.Interfaces;

namespace Ntk.Note.IP.Infrastructure.Data;

public sealed class UnitOfWork(IApplicationDbContext context) : IUnitOfWork
{
    public Task<int> SaveChangesAsync(CancellationToken cancellationToken = default) =>
        context.SaveChangesAsync(cancellationToken);
}
