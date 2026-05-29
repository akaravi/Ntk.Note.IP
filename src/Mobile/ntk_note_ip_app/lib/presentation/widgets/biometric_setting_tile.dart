import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../providers/settings_controller.dart';

class BiometricSettingTile extends ConsumerStatefulWidget {
  const BiometricSettingTile({super.key});

  @override
  ConsumerState<BiometricSettingTile> createState() =>
      _BiometricSettingTileState();
}

class _BiometricSettingTileState extends ConsumerState<BiometricSettingTile> {
  bool _busy = false;

  Future<void> _onChanged(bool? value) async {
    if (value == null || _busy) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);

    final error = await ref
        .read(settingsControllerProvider.notifier)
        .setBiometricUnlock(
          enabled: value,
          authReason: l10n.biometricUnlockReason,
        );

    if (!mounted) {
      return;
    }

    setState(() => _busy = false);

    if (error == 'unavailable') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.biometricUnavailable)),
      );
    } else if (error == 'failed') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.biometricUnlockFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsControllerProvider).valueOrNull;
    final enabled = settings?.biometricUnlockEnabled ?? false;

    return Card(
      child: SwitchListTile(
        secondary: const Icon(Icons.fingerprint),
        title: Text(l10n.biometricSettingTitle),
        subtitle: Text(l10n.biometricSettingSubtitle),
        value: enabled,
        onChanged: _busy ? null : _onChanged,
      ),
    );
  }
}
