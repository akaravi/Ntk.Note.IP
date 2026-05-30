import '../../api/generated/models/access_token_response.dart';
import '../../core/auth/auth_tokens.dart';

AuthTokens authTokensFromAccessTokenResponse(AccessTokenResponse response) {
  DateTime? expiresAt;
  final expiresIn = response.expiresIn;
  if (expiresIn is num) {
    expiresAt = DateTime.now().add(Duration(seconds: expiresIn.toInt()));
  }

  return AuthTokens(
    accessToken: response.accessToken,
    refreshToken: response.refreshToken,
    expiresAt: expiresAt,
  );
}
