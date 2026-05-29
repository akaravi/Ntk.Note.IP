import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/auth/auth_tokens.dart';
import 'package:ntk_note_ip_app/core/auth/biometric_auth_service.dart';
import 'package:ntk_note_ip_app/core/settings/app_settings.dart';
import 'package:ntk_note_ip_app/presentation/providers/app_lock_controller.dart';
import 'package:ntk_note_ip_app/presentation/providers/auth_controller.dart';
import 'package:ntk_note_ip_app/presentation/providers/settings_controller.dart';

class _FakeBiometricAuthService implements BiometricAuthService {
  _FakeBiometricAuthService({this.authenticateOk = true});

  final bool authenticateOk;

  @override
  Future<bool> get canCheckBiometrics async => true;

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    return authenticateOk;
  }
}

class _SignedInAuthController extends AuthController {
  @override
  AuthState build() {
    return const AuthState(
      loading: false,
      tokens: AuthTokens(accessToken: 'token', refreshToken: 'refresh'),
    );
  }
}

class _BiometricOnSettingsController extends SettingsController {
  @override
  Future<AppSettings> build() async {
    return AppSettings.defaults.copyWith(biometricUnlockEnabled: true);
  }
}

void main() {
  test('locks for signed-in user with biometric enabled', () async {
    final container = ProviderContainer(
      overrides: [
        biometricAuthServiceProvider.overrideWithValue(
          _FakeBiometricAuthService(),
        ),
        authControllerProvider.overrideWith(_SignedInAuthController.new),
        settingsControllerProvider.overrideWith(
          _BiometricOnSettingsController.new,
        ),
      ],
    );
    addTearDown(container.dispose);

    container.read(appLockControllerProvider);
    await container.read(settingsControllerProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(container.read(appLockControllerProvider).locked, isTrue);
  });

  test('unlock clears lock when biometric succeeds', () async {
    final container = ProviderContainer(
      overrides: [
        biometricAuthServiceProvider.overrideWithValue(
          _FakeBiometricAuthService(authenticateOk: true),
        ),
        authControllerProvider.overrideWith(_SignedInAuthController.new),
        settingsControllerProvider.overrideWith(
          _BiometricOnSettingsController.new,
        ),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(appLockControllerProvider.notifier);
    await container.read(settingsControllerProvider.future);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    notifier.lock();
    final ok = await notifier.unlock(localizedReason: 'test');
    expect(ok, isTrue);
    expect(container.read(appLockControllerProvider).locked, isFalse);
  });
}
