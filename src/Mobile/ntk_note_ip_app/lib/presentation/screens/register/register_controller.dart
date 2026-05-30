import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback/app_haptics.dart';
import '../../providers/app_providers.dart';

const registerMinPasswordLength = 6;

class RegisterState {
  const RegisterState({
    this.submitting = false,
    this.error,
  });

  final bool submitting;
  final String? error;

  RegisterState copyWith({
    bool? submitting,
    String? error,
    bool clearError = false,
  }) {
    return RegisterState(
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class RegisterFormController extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(submitting: true, clearError: true);
    final result = await ref.read(authRepositoryProvider).register(
          email: email.trim(),
          password: password,
        );

    if (result.isSuccess) {
      await AppHaptics.success();
      state = const RegisterState();
      return true;
    }

    state = state.copyWith(
      submitting: false,
      error: result.errorMessage ?? 'Registration failed',
    );
    return false;
  }
}

final registerFormControllerProvider =
    NotifierProvider<RegisterFormController, RegisterState>(
  RegisterFormController.new,
);
