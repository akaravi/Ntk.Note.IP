using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Application.Common.Security;
using Ntk.Note.IP.Application.IpLookup;
using Ntk.Note.IP.Domain.Entities;
using Ntk.Note.IP.Domain.ValueObjects;

namespace Ntk.Note.IP.Application.IpNotes.Commands.AddIpNote;

[Authorize]
public record AddIpNoteCommand : IRequest<int>
{
    public string Address { get; init; } = string.Empty;

    public string? Title { get; init; }

    public string? Body { get; init; }

    public string? Tags { get; init; }

    public DateTimeOffset? NotedAtClient { get; init; }

    public string? ClientTimezone { get; init; }

    public string? LocalIpAddress { get; init; }

    public IpNoteDeviceInfoDto? DeviceInfo { get; init; }

    public IpDetailsDto? IpSnapshot { get; init; }
}

public class AddIpNoteCommandValidator : AbstractValidator<AddIpNoteCommand>
{
    public AddIpNoteCommandValidator()
    {
        RuleFor(v => v.Address)
            .NotEmpty()
            .Must(a => IpAddress.TryParse(a, out _))
            .WithMessage("Address must be a valid IPv4 or IPv6 address.");

        RuleFor(v => v.Title)
            .MaximumLength(200);

        RuleFor(v => v.Body)
            .MaximumLength(8000);

        RuleFor(v => v.Tags)
            .MaximumLength(500);

        RuleFor(v => v.ClientTimezone)
            .MaximumLength(100);

        RuleFor(v => v.LocalIpAddress)
            .MaximumLength(45);
    }
}

public class AddIpNoteCommandHandler : IRequestHandler<AddIpNoteCommand, int>
{
    private readonly IApplicationDbContext _context;

    public AddIpNoteCommandHandler(IApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<int> Handle(AddIpNoteCommand request, CancellationToken cancellationToken)
    {
        var normalized = IpAddress.Parse(request.Address).Value;
        var snapshot = request.IpSnapshot;

        var entity = new IpNote
        {
            Address = normalized,
            Title = request.Title,
            Body = request.Body,
            Tags = request.Tags,
            NotedAtClient = request.NotedAtClient ?? DateTimeOffset.UtcNow,
            ClientTimezone = request.ClientTimezone?.Trim(),
            LocalIpAddress = request.LocalIpAddress?.Trim(),
            CountryCode = snapshot?.Geo.CountryCode,
            Region = snapshot?.Geo.Region,
            City = snapshot?.Geo.City,
            Isp = snapshot?.Isp,
            Asn = FormatAsn(snapshot?.Asn),
            DeviceLabel = request.DeviceInfo?.Label,
            DeviceInfoJson = IpNoteSnapshotJson.SerializeDevice(request.DeviceInfo),
            IpSnapshotJson = IpNoteSnapshotJson.SerializeIpSnapshot(snapshot)
        };

        _context.IpNotes.Add(entity);
        await _context.SaveChangesAsync(cancellationToken);

        return entity.Id;
    }

    private static string? FormatAsn(AsnInfoDto? asn)
    {
        if (asn == null)
        {
            return null;
        }

        if (!string.IsNullOrWhiteSpace(asn.Number) && !string.IsNullOrWhiteSpace(asn.Organization))
        {
            return $"AS{asn.Number} {asn.Organization}";
        }

        return asn.Number != null ? $"AS{asn.Number}" : asn.Organization;
    }
}
