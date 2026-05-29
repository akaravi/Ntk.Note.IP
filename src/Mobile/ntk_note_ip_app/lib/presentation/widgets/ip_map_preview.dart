import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/map/osm_static_map.dart';
import '../../domain/entities/ip_details.dart';

class IpMapPreview extends StatelessWidget {
  const IpMapPreview({
    super.key,
    required this.geo,
    required this.openMapLabel,
  });

  final GeoLocation geo;
  final String openMapLabel;

  @override
  Widget build(BuildContext context) {
    if (!geo.hasCoordinates) {
      return const SizedBox.shrink();
    }

    final lat = geo.latitude!;
    final lon = geo.longitude!;
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: scheme.surfaceContainerHighest,
        child: InkWell(
          onTap: () => launchUrl(
            Uri.parse(OsmStaticMap.openUrl(lat, lon)),
            mode: LaunchMode.externalApplication,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                OsmStaticMap.imageUrl(latitude: lat, longitude: lon),
                height: 160,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => SizedBox(
                  height: 160,
                  child: Center(
                    child: Icon(Icons.map_outlined, color: scheme.outline),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  openMapLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
