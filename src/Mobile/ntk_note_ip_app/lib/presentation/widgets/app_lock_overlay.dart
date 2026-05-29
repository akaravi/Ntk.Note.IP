import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../providers/app_lock_controller.dart';

/// Full-screen lock when biometric unlock is enabled and user is signed in.
class AppLockOverlay extends ConsumerStatefulWidget {
  const AppLockOverlay({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockOverlay> createState() => _AppLockOverlayState();
}

class _AppLockOverlayState extends ConsumerState<AppLockOverlay>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(appLockControllerProvider.notifier).lock();
    }
  }

  Future<void> _unlock() async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref
        .read(appLockControllerProvider.notifier)
        .unlock(localizedReason: l10n.biometricUnlockReason);
    if (!ok && mounted) {
      ref.read(appLockControllerProvider.notifier).setUnlockError(
            l10n.biometricUnlockFailed,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lock = ref.watch(appLockControllerProvider);
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (lock.locked)
          Material(
            color: scheme.surface.withValues(alpha: 0.98),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fingerprint,
                        size: 72,
                        color: scheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.biometricLockTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.biometricLockSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      if (lock.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          lock.errorMessage!,
                          style: TextStyle(color: scheme.error),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 28),
                      FilledButton.icon(
                        onPressed: lock.unlocking ? null : _unlock,
                        icon: lock.unlocking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.lock_open),
                        label: Text(l10n.biometricUnlockAction),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
