import { apiV1Group } from './api-routes';

export interface GeoMarker {
  lat: number;
  lon: number;
}

function normalizeBaseUrl(apiBaseUrl: string): string {
  return apiBaseUrl.replace(/\/$/, '');
}

export function buildStaticMapUrl(
  apiBaseUrl: string,
  latitude: number,
  longitude: number,
  width = 640,
  height = 280,
  zoom = 10
): string {
  const base = normalizeBaseUrl(apiBaseUrl);
  const params = new URLSearchParams({
    latitude: latitude.toFixed(5),
    longitude: longitude.toFixed(5),
    width: String(width),
    height: String(height),
    zoom: String(zoom),
  });

  return `${base}${apiV1Group('OsmMap')}/GetStatic?${params.toString()}`;
}

export function buildAggregateStaticMapUrl(
  apiBaseUrl: string,
  markers: GeoMarker[],
  width = 640,
  height = 300
): string | null {
  if (markers.length === 0) {
    return null;
  }

  const zoom = markers.length === 1 ? 8 : markers.length <= 4 ? 4 : 2;
  const markerParam = markers
    .slice(0, 15)
    .map((marker) => `${marker.lat.toFixed(5)},${marker.lon.toFixed(5)}`)
    .join('|');

  const base = normalizeBaseUrl(apiBaseUrl);
  const params = new URLSearchParams({
    markers: markerParam,
    width: String(width),
    height: String(height),
    zoom: String(zoom),
  });

  return `${base}${apiV1Group('OsmMap')}/GetStatic?${params.toString()}`;
}

export function buildOpenStreetMapUrl(latitude: number, longitude: number): string {
  const lat = latitude.toFixed(5);
  const lon = longitude.toFixed(5);
  return `https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=12/${lat}/${lon}`;
}
