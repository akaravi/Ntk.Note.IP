namespace Ntk.Note.IP.Application.Admin;

public class AdminDashboardDto
{
    public int UserCount { get; init; }

    public int IpNoteCount { get; init; }

    public int IpLookupRecordCount { get; init; }

    public int PushDeviceCount { get; init; }

    public int OutboxPendingCount { get; init; }

    public int IpSnapshotCount { get; init; }
}
