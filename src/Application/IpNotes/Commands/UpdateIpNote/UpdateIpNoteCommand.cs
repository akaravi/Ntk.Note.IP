using Microsoft.EntityFrameworkCore;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpNotes.Commands.UpdateIpNote;

[Authorize]
public record UpdateIpNoteCommand : IRequest
{
    public int Id { get; init; }

    public string Address { get; init; } = string.Empty;

    public string? Title { get; init; }

    public string? Body { get; init; }

    public string? Tags { get; init; }
}

public class UpdateIpNoteCommandValidator : AbstractValidator<UpdateIpNoteCommand>
{
    public UpdateIpNoteCommandValidator()
    {
        RuleFor(v => v.Id).GreaterThan(0);

        RuleFor(v => v.Address)
            .NotEmpty()
            .Must(a => IpAddress.TryParse(a, out _))
            .WithMessage("Address must be a valid IPv4 or IPv6 address.");

        RuleFor(v => v.Title).MaximumLength(200);
        RuleFor(v => v.Body).MaximumLength(8000);
        RuleFor(v => v.Tags).MaximumLength(500);
    }
}

public class UpdateIpNoteCommandHandler : IRequestHandler<UpdateIpNoteCommand>
{
    private readonly IApplicationDbContext _context;
    private readonly IUser _user;

    public UpdateIpNoteCommandHandler(IApplicationDbContext context, IUser user)
    {
        _context = context;
        _user = user;
    }

    public async Task Handle(UpdateIpNoteCommand request, CancellationToken cancellationToken)
    {
        var userId = IpNoteUserScope.RequireUserId(_user);

        var entity = await _context.IpNotes
            .OwnedBy(userId)
            .FirstOrDefaultAsync(n => n.Id == request.Id, cancellationToken);

        Guard.Against.NotFound(request.Id, entity);

        entity.Address = IpAddress.Parse(request.Address).Value;
        entity.Title = request.Title;
        entity.Body = request.Body;
        entity.Tags = request.Tags;

        await _context.SaveChangesAsync(cancellationToken);
    }
}
