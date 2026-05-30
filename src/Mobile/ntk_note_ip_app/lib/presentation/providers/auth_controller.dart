import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_tokens.dart';
import '../../core/network/api_result.dart';
import '../../domain/repositories/auth_repository.dart';
import 'app_providers.dart';
import 'ip_history_provider.dart' show ipHistoryListProvider;

class AuthState {
  const AuthState({
    this.loading = true,
    this.tokens,
  });

  final bool loading;
  final AuthTokens? tokens;

  bool get isAuthenticated => tokens?.isValid == true;

  AuthState copyWith({
    bool? loading,
    AuthTokens? tokens,
    bool clearTokens = false,
  }) {
    return AuthState(
      loading: loading ?? this.loading,
      tokens: clearTokens ? null : (tokens ?? this.tokens),
    );
  }
}

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    Future.microtask(_loadStored);
    return const AuthState(loading: true);
  }

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> _loadStored() async {
    try {
      final tokens = await _repo.getStoredTokens();
      if (tokens == null || !tokens.isValid) {
        state = const AuthState(loading: false);
        return;
      }

      if (tokens.refreshToken.isNotEmpty &&
          (tokens.shouldRefreshAccessToken || tokens.expiresAt == null)) {
        final refresh = await _repo.refreshTokens();
        if (refresh.isSuccess && refresh.data != null) {
          state = AuthState(loading: false, tokens: refresh.data);
          _schedulePostAuthWork();
          return;
        }

        await _repo.logout();
        state = const AuthState(loading: false);
        return;
      }

      state = AuthState(loading: false, tokens: tokens);
      _schedulePostAuthWork();
    } catch (_) {
      state = const AuthState(loading: false);
    }
  }

  void _schedulePostAuthWork() {
    Future(_afterAuthenticated);
  }

  Future<void> _afterAuthenticated() async {
    await ref.read(ipHistorySyncServiceProvider).syncAfterAuthentication();
    ref.invalidate(ipHistoryListProvider);
    await ref.read(pushRegistrationServiceProvider).registerForAuthenticatedUser();
    ref.read(pushIpMonitorListenerProvider).bind();
  }

  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    state = state.copyWith(loading: true);
    final result = await _repo.login(
      email: email,
      password: password,
      rememberMe: rememberMe,
    );
    if (result.isSuccess && result.data != null) {
      state = AuthState(loading: false, tokens: result.data);
      _schedulePostAuthWork();
    } else {
      state = state.copyWith(loading: false);
    }

    return result;
  }

  void applyTokens(AuthTokens tokens) {
    state = state.copyWith(tokens: tokens);
  }

  Future<void> logout() async {
    await ref.read(pushRegistrationServiceProvider).unregisterLastToken();
    ref.read(ipHistorySyncServiceProvider).resetSession();
    await _repo.logout();
    state = const AuthState(loading: false, tokens: null);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthState>(AuthController.new);
