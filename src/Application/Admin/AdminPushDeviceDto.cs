namespace Ntk.Note.IP.Application.Admin;

public class AdminPushDeviceDto
{
    public int Id { get; init; }

    public string DeviceToken { get; init; } = string.Empty;

    public string Platform { get; init; } = string.Empty;

    public string? OwnerId { get; init; }

    public DateTimeOffset Created { get; init; }

    public DateTimeOffset LastModified { get; init; }
}
