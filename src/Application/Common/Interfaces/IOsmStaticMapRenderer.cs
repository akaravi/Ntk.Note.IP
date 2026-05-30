namespace Ntk.Note.IP.Application.Common.Interfaces;

public readonly record struct MapCoordinate(double Latitude, double Longitude);

public interface IOsmStaticMapRenderer
{
    Task<byte[]> RenderAsync(
        IReadOnlyList<MapCoordinate> markers,
        int width,
        int height,
        int? zoom,
        CancellationToken cancellationToken = default);
}
