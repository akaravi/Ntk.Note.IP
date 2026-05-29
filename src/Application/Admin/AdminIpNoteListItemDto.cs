namespace Ntk.Note.IP.Application.Admin;

public record AdminIpNoteListItemDto
{
    public int Id { get; init; }

    public string Address { get; init; } = string.Empty;

    public string? Title { get; init; }

    public string? Body { get; init; }

    public string? Tags { get; init; }

    public string? OwnerId { get; init; }

    public string? OwnerEmail { get; init; }

    public DateTimeOffset Created { get; init; }

    public DateTimeOffset LastModified { get; init; }

    public string? CountryCode { get; init; }

    public string? City { get; init; }

    public string? DeviceLabel { get; init; }

    public bool IsSoftDeleted { get; init; }
}
