import '../../core/auth/auth_token_store.dart';
import '../../core/auth/auth_tokens.dart';
import '../../core/network/api_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_port.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._store);

  final AuthRemotePort _remote;
  final AuthTokenStorePort _store;

  @override
  Future<AuthTokens?> getStoredTokens() => _store.read();

  @override
  Future<ApiResult<void>> register({
    required String email,
    required String password,
  }) =>
      _remote.register(email: email, password: password);

  @override
  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    final result = await _remote.login(email: email, password: password);
    if (result.isSuccess && result.data != null && result.data!.isValid) {
      await _store.write(result.data!, persist: rememberMe);
    }

    return result;
  }

  @override
  Future<ApiResult<AuthTokens>> refreshTokens() async {
    final stored = await _store.read();
    if (stored == null || stored.refreshToken.isEmpty) {
      return ApiResult.fail('No refresh token');
    }

    final result =
        await _remote.refresh(refreshToken: stored.refreshToken);
    if (result.isSuccess && result.data != null && result.data!.isValid) {
      final persist = await _store.isPersistentSession();
      await _store.write(result.data!, persist: persist);
    }

    return result;
  }

  @override
  Future<void> logout() => _store.clear();
}
