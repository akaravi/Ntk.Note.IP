import '../../core/auth/auth_tokens.dart';
import '../../core/network/api_result.dart';

abstract class AuthRepository {
  Future<AuthTokens?> getStoredTokens();

  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthTokens>> refreshTokens();

  Future<void> logout();
}
