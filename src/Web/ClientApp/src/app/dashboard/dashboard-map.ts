export interface GeoMarker {
  lat: number;
  lon: number;
  label?: string;
}

export function buildAggregateMapUrl(markers: GeoMarker[]): string | null {
  if (markers.length === 0) {
    return null;
  }

  const avgLat = markers.reduce((sum, marker) => sum + marker.lat, 0) / markers.length;
  const avgLon = markers.reduce((sum, marker) => sum + marker.lon, 0) / markers.length;
  const zoom = markers.length === 1 ? 8 : markers.length <= 4 ? 4 : 2;
  const markerParam = markers
    .slice(0, 15)
    .map((marker) => `${marker.lat},${marker.lon},red`)
    .join('|');

  return `https://staticmap.openstreetmap.de/staticmap.php?center=${avgLat},${avgLon}&zoom=${zoom}&size=640x300&markers=${markerParam}`;
}
