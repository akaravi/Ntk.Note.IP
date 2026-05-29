using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.Constants;

namespace Ntk.Note.IP.Application.Admin.Queries.GetListAdminIpNotes;

[Authorize(Roles = Roles.Administrator)]
public record GetListAdminIpNotesQuery(string? Search = null) : IRequest<List<AdminIpNoteListItemDto>>;

public class GetListAdminIpNotesQueryHandler : IRequestHandler<GetListAdminIpNotesQuery, List<AdminIpNoteListItemDto>>
{
    private readonly IApplicationDbContext _context;
    private readonly IAdminUserService _adminUsers;

    public GetListAdminIpNotesQueryHandler(IApplicationDbContext context, IAdminUserService adminUsers)
    {
        _context = context;
        _adminUsers = adminUsers;
    }

    public async Task<List<AdminIpNoteListItemDto>> Handle(GetListAdminIpNotesQuery request, CancellationToken cancellationToken)
    {
        var users = await _adminUsers.GetListAsync(cancellationToken);
        var emailById = users.ToDictionary(u => u.Id, u => u.Email ?? u.UserName ?? u.Id);

        var query = _context.IpNotes.AsNoTracking();

        if (!string.IsNullOrWhiteSpace(request.Search))
        {
            var term = request.Search.Trim();
            query = query.Where(n =>
                n.Address.Contains(term) ||
                (n.Title != null && n.Title.Contains(term)) ||
                (n.Body != null && n.Body.Contains(term)) ||
                (n.Tags != null && n.Tags.Contains(term)));
        }

        var notes = await query
            .OrderByDescending(n => n.Id)
            .Take(500)
            .Select(n => new
            {
                n.Id,
                n.Address,
                n.Title,
                n.Body,
                n.Tags,
                OwnerId = n.CreatedBy,
                n.Created,
                n.LastModified,
                n.CountryCode,
                n.City,
                n.DeviceLabel,
                n.IsSoftDeleted,
            })
            .ToListAsync(cancellationToken);

        return notes
            .Select(n => new AdminIpNoteListItemDto
            {
                Id = n.Id,
                Address = n.Address,
                Title = n.Title,
                Body = n.Body,
                Tags = n.Tags,
                OwnerId = n.OwnerId,
                OwnerEmail = n.OwnerId is not null && emailById.TryGetValue(n.OwnerId, out var email) ? email : null,
                Created = n.Created,
                LastModified = n.LastModified,
                CountryCode = n.CountryCode,
                City = n.City,
                DeviceLabel = n.DeviceLabel,
                IsSoftDeleted = n.IsSoftDeleted,
            })
            .ToList();
    }
}
