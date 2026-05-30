abstract final class ApiRoutes {
  /// Short alias for GetMyIpPlain — must match Program.cs MapGet("/myIp").
  static const myIpShortPath = '/myip';

  static String myIpPlainUrl(String apiBaseUrl) {
    final base = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;
    return '$base$myIpShortPath';
  }
}
