import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/api/generated/models/access_token_response.dart';
import 'package:ntk_note_ip_app/core/auth/auth_token_mapper.dart';

void main() {
  test('maps AccessTokenResponse to AuthTokens', () {
    const response = AccessTokenResponse(
      accessToken: 'access',
      refreshToken: 'refresh',
      expiresIn: 3600,
    );

    final tokens = authTokensFromAccessTokenResponse(response);
    expect(tokens.accessToken, 'access');
    expect(tokens.refreshToken, 'refresh');
    expect(tokens.isValid, isTrue);
  });
}
