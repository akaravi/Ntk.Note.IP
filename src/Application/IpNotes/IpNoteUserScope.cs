using Ntk.Note.IP.Application.Common.Exceptions;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Domain.Entities;

namespace Ntk.Note.IP.Application.IpNotes;

internal static class IpNoteUserScope
{
    public static string RequireUserId(IUser user) =>
        string.IsNullOrEmpty(user.Id) ? throw new ForbiddenAccessException() : user.Id;

    public static IQueryable<IpNote> OwnedBy(this IQueryable<IpNote> query, string userId) =>
        query.Where(n => n.CreatedBy == userId);
}
