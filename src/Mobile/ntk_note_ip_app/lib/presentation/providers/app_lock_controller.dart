import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/biometric_auth_service.dart';
import 'auth_controller.dart';
import 'settings_controller.dart';

class AppLockState {
  const AppLockState({
    this.locked = false,
    this.unlocking = false,
    this.errorMessage,
  });

  final bool locked;
  final bool unlocking;
  final String? errorMessage;

  AppLockState copyWith({
    bool? locked,
    bool? unlocking,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AppLockState(
      locked: locked ?? this.locked,
      unlocking: unlocking ?? this.unlocking,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AppLockController extends Notifier<AppLockState> {
  @override
  AppLockState build() {
    ref.listen(authControllerProvider, (previous, next) {
      if (!next.loading) {
        _applyLockPolicy();
      }
    });
    ref.listen(settingsControllerProvider, (previous, next) {
      if (next.hasValue) {
        _applyLockPolicy();
      }
    });

    Future.microtask(_applyLockPolicy);
    return const AppLockState();
  }

  BiometricAuthService get _biometric => ref.read(biometricAuthServiceProvider);

  void _applyLockPolicy() {
    final auth = ref.read(authControllerProvider);
    final settings = ref.read(settingsControllerProvider).valueOrNull;

    if (auth.loading) {
      return;
    }

    if (!auth.isAuthenticated ||
        settings == null ||
        !settings.biometricUnlockEnabled) {
      state = const AppLockState(locked: false);
      return;
    }

    state = state.copyWith(locked: true, clearError: true);
  }

  void lock() {
    final auth = ref.read(authControllerProvider);
    final settings = ref.read(settingsControllerProvider).valueOrNull;
    if (auth.isAuthenticated && settings?.biometricUnlockEnabled == true) {
      state = const AppLockState(locked: true);
    }
  }

  Future<bool> unlock({required String localizedReason}) async {
    if (!state.locked) {
      return true;
    }

    state = state.copyWith(unlocking: true, clearError: true);
    final ok = await _biometric.authenticate(localizedReason: localizedReason);
    if (ok) {
      state = const AppLockState(locked: false);
      return true;
    }

    state = state.copyWith(unlocking: false, locked: true);
    return false;
  }

  void setUnlockError(String message) {
    state = state.copyWith(unlocking: false, locked: true, errorMessage: message);
  }

  void unlockSilently() {
    state = const AppLockState(locked: false);
  }
}

final biometricAuthServiceProvider = Provider<BiometricAuthService>((ref) {
  return LocalBiometricAuthService();
});

final appLockControllerProvider =
    NotifierProvider<AppLockController, AppLockState>(AppLockController.new);
