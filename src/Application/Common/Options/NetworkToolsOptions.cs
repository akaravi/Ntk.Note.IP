namespace Ntk.Note.IP.Application.Common.Options;

public class NetworkToolsOptions
{
    public const string SectionName = "NetworkTools";

    public string PortCheckProvider { get; set; } = "Fake";

    public string SslProvider { get; set; } = "Fake";
}
