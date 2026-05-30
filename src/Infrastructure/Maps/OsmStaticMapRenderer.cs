using System.Globalization;
using Microsoft.Extensions.Caching.Memory;
using Ntk.Note.IP.Application.Common.Interfaces;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.PixelFormats;
using SixLabors.ImageSharp.Processing;

namespace Ntk.Note.IP.Infrastructure.Maps;

public sealed class OsmStaticMapRenderer : IOsmStaticMapRenderer
{
    private const int TileSize = 256;
    private const string TileBaseUrl = "https://tile.openstreetmap.org";

    private readonly HttpClient _httpClient;
    private readonly IMemoryCache _cache;

    public OsmStaticMapRenderer(HttpClient httpClient, IMemoryCache cache)
    {
        _httpClient = httpClient;
        _cache = cache;
    }

    public async Task<byte[]> RenderAsync(
        IReadOnlyList<MapCoordinate> markers,
        int width,
        int height,
        int? zoom,
        CancellationToken cancellationToken = default)
    {
        if (markers.Count == 0)
        {
            throw new ArgumentException("At least one marker is required.", nameof(markers));
        }

        width = Math.Clamp(width, 64, 1280);
        height = Math.Clamp(height, 64, 720);
        var effectiveZoom = zoom ?? ResolveZoom(markers);

        var cacheKey = BuildCacheKey(markers, width, height, effectiveZoom);
        if (_cache.TryGetValue(cacheKey, out byte[]? cached) && cached is not null)
        {
            return cached;
        }

        var center = ResolveCenter(markers);
        var centerPixel = LatLonToPixel(center.Latitude, center.Longitude, effectiveZoom);
        var topLeftX = centerPixel.X - width / 2.0;
        var topLeftY = centerPixel.Y - height / 2.0;

        using var image = new Image<Rgba32>(width, height);
        FillBackground(image, Color.FromRgb(235, 243, 238));

        var minTileX = (int)Math.Floor(topLeftX / TileSize);
        var minTileY = (int)Math.Floor(topLeftY / TileSize);
        var maxTileX = (int)Math.Floor((topLeftX + width - 1) / TileSize);
        var maxTileY = (int)Math.Floor((topLeftY + height - 1) / TileSize);
        var maxIndex = (1 << effectiveZoom) - 1;

        for (var tileX = minTileX; tileX <= maxTileX; tileX++)
        {
            for (var tileY = minTileY; tileY <= maxTileY; tileY++)
            {
                if (tileX < 0 || tileY < 0 || tileX > maxIndex || tileY > maxIndex)
                {
                    continue;
                }

                await using var tileStream = await FetchTileAsync(effectiveZoom, tileX, tileY, cancellationToken);
                using var tileImage = await Image.LoadAsync<Rgba32>(tileStream, cancellationToken);
                var destX = (int)Math.Round(tileX * TileSize - topLeftX);
                var destY = (int)Math.Round(tileY * TileSize - topLeftY);
                image.Mutate(ctx => ctx.DrawImage(tileImage, new Point(destX, destY), 1f));
            }
        }

        foreach (var marker in markers)
        {
            var markerPixel = LatLonToPixel(marker.Latitude, marker.Longitude, effectiveZoom);
            DrawMarker(
                image,
                (int)Math.Round(markerPixel.X - topLeftX),
                (int)Math.Round(markerPixel.Y - topLeftY));
        }

        using var output = new MemoryStream();
        await image.SaveAsPngAsync(output, cancellationToken);
        var bytes = output.ToArray();

        _cache.Set(cacheKey, bytes, TimeSpan.FromHours(6));
        return bytes;
    }

    private async Task<Stream> FetchTileAsync(
        int zoom,
        int tileX,
        int tileY,
        CancellationToken cancellationToken)
    {
        var url = $"{TileBaseUrl}/{zoom}/{tileX}/{tileY}.png";
        using var response = await _httpClient.GetAsync(url, cancellationToken);
        response.EnsureSuccessStatusCode();
        var bytes = await response.Content.ReadAsByteArrayAsync(cancellationToken);
        return new MemoryStream(bytes, writable: false);
    }

    private static void FillBackground(Image<Rgba32> image, Color color)
    {
        for (var y = 0; y < image.Height; y++)
        {
            for (var x = 0; x < image.Width; x++)
            {
                image[x, y] = color;
            }
        }
    }

    private static void DrawMarker(Image<Rgba32> image, int x, int y)
    {
        const int outerRadius = 9;
        const int innerRadius = 6;

        for (var dy = -outerRadius; dy <= outerRadius; dy++)
        {
            for (var dx = -outerRadius; dx <= outerRadius; dx++)
            {
                var distanceSquared = dx * dx + dy * dy;
                if (distanceSquared > outerRadius * outerRadius)
                {
                    continue;
                }

                var px = x + dx;
                var py = y + dy;
                if (px < 0 || py < 0 || px >= image.Width || py >= image.Height)
                {
                    continue;
                }

                image[px, py] = distanceSquared <= innerRadius * innerRadius
                    ? Color.FromRgb(220, 38, 38)
                    : Color.FromRgb(255, 255, 255);
            }
        }
    }

    private static MapCoordinate ResolveCenter(IReadOnlyList<MapCoordinate> markers)
    {
        var lat = markers.Average(marker => marker.Latitude);
        var lon = markers.Average(marker => marker.Longitude);
        return new MapCoordinate(lat, lon);
    }

    private static int ResolveZoom(IReadOnlyList<MapCoordinate> markers)
    {
        if (markers.Count == 1)
        {
            return 10;
        }

        if (markers.Count <= 4)
        {
            return 4;
        }

        return 2;
    }

    private static (double X, double Y) LatLonToPixel(double latitude, double longitude, int zoom)
    {
        var scale = 1 << zoom;
        var latRad = latitude * Math.PI / 180.0;
        var x = (longitude + 180.0) / 360.0 * scale * TileSize;
        var y = (1.0 - Math.Log(Math.Tan(latRad) + 1 / Math.Cos(latRad)) / Math.PI) / 2.0 * scale * TileSize;
        return (x, y);
    }

    private static string BuildCacheKey(
        IReadOnlyList<MapCoordinate> markers,
        int width,
        int height,
        int zoom)
    {
        var markerKey = string.Join(
            '|',
            markers.Select(marker =>
                string.Create(
                    CultureInfo.InvariantCulture,
                    $"{marker.Latitude:F5},{marker.Longitude:F5}")));

        return $"osm-static:{width}x{height}:z{zoom}:{markerKey}";
    }
}
