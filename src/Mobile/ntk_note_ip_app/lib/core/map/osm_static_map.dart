class GeoMarker {
  const GeoMarker({required this.lat, required this.lon, this.label});

  final double lat;
  final double lon;
  final String? label;
}

abstract final class OsmStaticMap {
  static String imageUrl({
    required double latitude,
    required double longitude,
    int width = 640,
    int height = 280,
    int zoom = 10,
  }) {
    final lat = latitude.toStringAsFixed(5);
    final lon = longitude.toStringAsFixed(5);
    return 'https://staticmap.openstreetmap.de/staticmap.php'
        '?center=$lat,$lon&zoom=$zoom&size=${width}x$height&markers=$lat,$lon,red';
  }

  static String? buildAggregateMapUrl(List<GeoMarker> markers) {
    if (markers.isEmpty) {
      return null;
    }

    final avgLat =
        markers.map((m) => m.lat).reduce((a, b) => a + b) / markers.length;
    final avgLon =
        markers.map((m) => m.lon).reduce((a, b) => a + b) / markers.length;
    final zoom = markers.length == 1
        ? 8
        : markers.length <= 4
            ? 4
            : 2;
    final markerParam = markers
        .take(15)
        .map((m) => '${m.lat.toStringAsFixed(5)},${m.lon.toStringAsFixed(5)},red')
        .join('|');

    return 'https://staticmap.openstreetmap.de/staticmap.php'
        '?center=$avgLat,$avgLon&zoom=$zoom&size=640x300&markers=$markerParam';
  }

  static String openUrl(double latitude, double longitude) {
    final lat = latitude.toStringAsFixed(5);
    final lon = longitude.toStringAsFixed(5);
    return 'https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=12/$lat/$lon';
  }
}
