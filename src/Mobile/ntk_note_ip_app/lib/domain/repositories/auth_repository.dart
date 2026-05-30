import '../../core/auth/auth_tokens.dart';
import '../../core/network/api_result.dart';

abstract class AuthRepository {
  Future<AuthTokens?> getStoredTokens();

  Future<ApiResult<void>> register({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  Future<ApiResult<AuthTokens>> refreshTokens();

  Future<void> logout();
}
