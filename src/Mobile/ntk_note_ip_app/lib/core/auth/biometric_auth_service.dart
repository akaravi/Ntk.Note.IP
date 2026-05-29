import 'package:local_auth/local_auth.dart';

/// Platform biometric gate (fingerprint / Face ID).
abstract class BiometricAuthService {
  Future<bool> get canCheckBiometrics;

  Future<bool> authenticate({required String localizedReason});
}

class LocalBiometricAuthService implements BiometricAuthService {
  LocalBiometricAuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> get canCheckBiometrics async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) {
        return false;
      }

      return await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
