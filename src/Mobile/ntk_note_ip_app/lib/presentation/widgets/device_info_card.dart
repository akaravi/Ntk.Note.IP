import 'package:flutter/material.dart';

import '../../core/device/device_info_summary.dart';
import '../../l10n/app_localizations.dart';
import 'info_row.dart';

class DeviceInfoCard extends StatelessWidget {
  const DeviceInfoCard({required this.info, super.key});

  final DeviceInfoSummary info;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.deviceTitle, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InfoRow(label: l10n.deviceBrowser, value: info.browser),
            InfoRow(label: l10n.deviceOs, value: info.os),
            InfoRow(label: l10n.deviceType, value: info.device),
            InfoRow(label: l10n.deviceLanguage, value: info.language),
          ],
        ),
      ),
    );
  }
}
