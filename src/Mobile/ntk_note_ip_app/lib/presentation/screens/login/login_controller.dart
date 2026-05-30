import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/feedback/app_haptics.dart';
import '../../providers/auth_controller.dart';

class LoginState {
  const LoginState({
    this.submitting = false,
    this.error,
    this.rememberMe = true,
  });

  final bool submitting;
  final String? error;
  final bool rememberMe;

  LoginState copyWith({
    bool? submitting,
    String? error,
    bool? rememberMe,
    bool clearError = false,
  }) {
    return LoginState(
      submitting: submitting ?? this.submitting,
      error: clearError ? null : (error ?? this.error),
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}

class LoginFormController extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  void setRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  Future<bool> submit(String email, String password) async {
    state = state.copyWith(submitting: true, clearError: true);
    final result = await ref.read(authControllerProvider.notifier).login(
          email: email.trim(),
          password: password,
          rememberMe: state.rememberMe,
        );

    if (result.isSuccess) {
      await AppHaptics.success();
      state = const LoginState();
      return true;
    }

    state = state.copyWith(
      submitting: false,
      error: result.errorMessage ?? 'Login failed',
    );
    return false;
  }
}

final loginFormControllerProvider =
    NotifierProvider<LoginFormController, LoginState>(LoginFormController.new);
