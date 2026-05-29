namespace Ntk.Note.IP.Application.Common.Options;

public class DatabaseOptions
{
    public const string SectionName = "Database";

    public string Provider { get; set; } = "Sqlite";
}
