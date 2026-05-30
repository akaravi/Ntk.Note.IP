using System.Globalization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.HttpResults;
using Ntk.Note.IP.Application.Common.Interfaces;
using Ntk.Note.IP.Web.Infrastructure;

namespace Ntk.Note.IP.Web.Endpoints;

public class OsmMap : IEndpointGroup
{
    public static void Map(RouteGroupBuilder groupBuilder)
    {
        groupBuilder.RequireRateLimiting(GuestRateLimitPolicies.GuestApi);
        groupBuilder.MapGet(GetStatic, "GetStatic").AllowAnonymous();
    }

    [EndpointSummary("GetStatic")]
    [EndpointDescription("Renders a PNG static map from OpenStreetMap tiles (replaces retired staticmap.openstreetmap.de).")]
    public static async Task<IResult> GetStatic(
        IOsmStaticMapRenderer renderer,
        double? latitude,
        double? longitude,
        string? markers,
        int width = 640,
        int height = 280,
        int? zoom = null,
        CancellationToken cancellationToken = default)
    {
        var coordinates = ParseMarkers(markers, latitude, longitude);
        if (coordinates.Count == 0)
        {
            return TypedResults.BadRequest("Provide latitude/longitude or markers=lat,lon|lat,lon.");
        }

        try
        {
            var png = await renderer.RenderAsync(coordinates, width, height, zoom, cancellationToken);
            return TypedResults.File(png, contentType: "image/png", enableRangeProcessing: true);
        }
        catch (Exception)
        {
            return TypedResults.StatusCode(StatusCodes.Status502BadGateway);
        }
    }

    private static List<MapCoordinate> ParseMarkers(
        string? markers,
        double? latitude,
        double? longitude)
    {
        var parsed = new List<MapCoordinate>();

        if (!string.IsNullOrWhiteSpace(markers))
        {
            foreach (var segment in markers.Split('|', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                var parts = segment.Split(',', StringSplitOptions.TrimEntries);
                if (parts.Length < 2)
                {
                    continue;
                }

                if (double.TryParse(parts[0], NumberStyles.Float, CultureInfo.InvariantCulture, out var lat)
                    && double.TryParse(parts[1], NumberStyles.Float, CultureInfo.InvariantCulture, out var lon))
                {
                    parsed.Add(new MapCoordinate(lat, lon));
                }
            }

            return parsed;
        }

        if (latitude is not null && longitude is not null)
        {
            parsed.Add(new MapCoordinate(latitude.Value, longitude.Value));
        }

        return parsed;
    }
}
