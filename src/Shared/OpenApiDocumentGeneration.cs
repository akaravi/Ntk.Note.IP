using System.Reflection;

namespace Ntk.Note.IP.Shared;

/// <summary>
/// Detects MSBuild OpenAPI document generation (dotnet-getdocument) at build/publish time.
/// </summary>
public static class OpenApiDocumentGeneration
{
    public static bool IsActive
    {
        get
        {
            var entryName = Assembly.GetEntryAssembly()?.GetName().Name ?? string.Empty;
            return entryName.Contains("GetDocument", StringComparison.OrdinalIgnoreCase)
                || entryName.Contains("dotnet-getdocument", StringComparison.OrdinalIgnoreCase);
        }
    }
}
