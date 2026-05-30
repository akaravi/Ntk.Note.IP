import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/auth/auth_token_store.dart';
import 'package:ntk_note_ip_app/core/auth/auth_tokens.dart';
import 'package:ntk_note_ip_app/core/network/api_result.dart';
import 'package:ntk_note_ip_app/data/datasources/auth_remote_port.dart';
import 'package:ntk_note_ip_app/data/repositories/auth_repository_impl.dart';

class _FakeAuthRemote implements AuthRemotePort {
  _FakeAuthRemote(this._refreshResult);

  final ApiResult<AuthTokens> _refreshResult;

  @override
  Future<ApiResult<void>> register({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<AuthTokens>> refresh({required String refreshToken}) async {
    return _refreshResult;
  }
}

class _InMemoryTokenStore implements AuthTokenStorePort {
  AuthTokens? tokens;
  bool persist = true;

  @override
  Future<AuthTokens?> read() async => tokens;

  @override
  Future<void> write(AuthTokens value, {required bool persist}) async {
    this.persist = persist;
    tokens = value;
  }

  @override
  Future<bool> isPersistentSession() async => persist;

  @override
  Future<void> clear() async {
    tokens = null;
    persist = true;
  }
}

void main() {
  test('refreshTokens persists new tokens on success', () async {
    final store = _InMemoryTokenStore();
    store.tokens = const AuthTokens(accessToken: 'old', refreshToken: 'rt-1');

    final repo = AuthRepositoryImpl(
      _FakeAuthRemote(
        ApiResult.ok(
          const AuthTokens(accessToken: 'new', refreshToken: 'rt-2'),
        ),
      ),
      store,
    );

    final result = await repo.refreshTokens();
    expect(result.isSuccess, isTrue);
    expect(result.data?.accessToken, 'new');
    expect(store.tokens?.accessToken, 'new');
    expect(store.tokens?.refreshToken, 'rt-2');
  });

  test('refreshTokens fails when no refresh token stored', () async {
    final repo = AuthRepositoryImpl(
      _FakeAuthRemote(
        ApiResult.ok(
          const AuthTokens(accessToken: 'x', refreshToken: 'y'),
        ),
      ),
      _InMemoryTokenStore(),
    );

    final result = await repo.refreshTokens();
    expect(result.isSuccess, isFalse);
  });
}
