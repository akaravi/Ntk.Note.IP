class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  bool get isValid => accessToken.isNotEmpty;

  bool get shouldRefreshAccessToken {
    if (expiresAt == null) {
      return refreshToken.isNotEmpty;
    }

    return DateTime.now().isAfter(expiresAt!.subtract(const Duration(minutes: 2)));
  }
}
