import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/notifications/notification_permission.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_controller.dart';

class BackgroundMonitorSettingTile extends ConsumerStatefulWidget {
  const BackgroundMonitorSettingTile({super.key});

  @override
  ConsumerState<BackgroundMonitorSettingTile> createState() =>
      _BackgroundMonitorSettingTileState();
}

class _BackgroundMonitorSettingTileState
    extends ConsumerState<BackgroundMonitorSettingTile> {
  bool _busy = false;

  Future<void> _onChanged(bool? value) async {
    if (value == null || _busy) {
      return;
    }

    if (value) {
      final allowed = await requestNotificationPermissionIfNeeded();
      if (!allowed && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).notificationPermissionDenied)),
        );
        return;
      }
    }

    setState(() => _busy = true);
    await ref.read(settingsControllerProvider.notifier).setBackgroundIpMonitor(value);
    if (mounted) {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final enabled = settings?.backgroundIpMonitorEnabled ?? false;

    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.wifi_tethering),
        title: Text(l10n.backgroundMonitorTitle),
        subtitle: Text(l10n.backgroundMonitorSubtitle),
        value: enabled,
        onChanged: _busy ? null : _onChanged,
      ),
    );
  }
}
