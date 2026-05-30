class GeoMarker {
  const GeoMarker({required this.lat, required this.lon, this.label});

  final double lat;
  final double lon;
  final String? label;
}

abstract final class OsmStaticMap {
  static String imageUrl({
    required String apiBaseUrl,
    required double latitude,
    required double longitude,
    int width = 640,
    int height = 280,
    int zoom = 10,
  }) {
    final base = _normalizeBaseUrl(apiBaseUrl);
    final lat = latitude.toStringAsFixed(5);
    final lon = longitude.toStringAsFixed(5);
    return '$base/api/v1/OsmMap/GetStatic'
        '?latitude=$lat&longitude=$lon&width=$width&height=$height&zoom=$zoom';
  }

  static String? buildAggregateMapUrl(
    String apiBaseUrl,
    List<GeoMarker> markers, {
    int width = 640,
    int height = 300,
  }) {
    if (markers.isEmpty) {
      return null;
    }

    final zoom = markers.length == 1
        ? 8
        : markers.length <= 4
            ? 4
            : 2;
    final markerParam = markers
        .take(15)
        .map((m) => '${m.lat.toStringAsFixed(5)},${m.lon.toStringAsFixed(5)}')
        .join('|');
    final base = _normalizeBaseUrl(apiBaseUrl);
    final uri = Uri.parse('$base/api/v1/OsmMap/GetStatic').replace(
      queryParameters: {
        'markers': markerParam,
        'width': '$width',
        'height': '$height',
        'zoom': '$zoom',
      },
    );
    return uri.toString();
  }

  static String openUrl(double latitude, double longitude) {
    final lat = latitude.toStringAsFixed(5);
    final lon = longitude.toStringAsFixed(5);
    return 'https://www.openstreetmap.org/?mlat=$lat&mlon=$lon#map=12/$lat/$lon';
  }

  static String _normalizeBaseUrl(String apiBaseUrl) {
    return apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;
  }
}
