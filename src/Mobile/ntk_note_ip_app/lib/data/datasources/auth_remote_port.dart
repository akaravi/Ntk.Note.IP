import '../../core/auth/auth_tokens.dart';
import '../../core/network/api_result.dart';

abstract class AuthRemotePort {
  Future<ApiResult<void>> register({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
  });

  Future<ApiResult<AuthTokens>> refresh({
    required String refreshToken,
  });
}
