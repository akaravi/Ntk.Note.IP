import '../../api/generated/models/access_token_response.dart';
import '../../core/auth/auth_tokens.dart';

AuthTokens authTokensFromAccessTokenResponse(AccessTokenResponse response) {
  return AuthTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
  );
}
