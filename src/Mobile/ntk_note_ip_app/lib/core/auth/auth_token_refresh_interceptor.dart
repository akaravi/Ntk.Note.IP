import 'package:dio/dio.dart';

/// On 401, refreshes the access token once and retries the failed request.
class AuthTokenRefreshInterceptor extends QueuedInterceptor {
  AuthTokenRefreshInterceptor({
    required Dio dio,
    required Future<String?> Function() onRefreshAccessToken,
  })  : _dio = dio,
        _onRefreshAccessToken = onRefreshAccessToken;

  final Dio _dio;
  final Future<String?> Function() _onRefreshAccessToken;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptRefresh(err)) {
      return handler.next(err);
    }

    final newAccess = await _onRefreshAccessToken();
    if (newAccess == null || newAccess.isEmpty) {
      return handler.next(err);
    }

    try {
      final request = err.requestOptions;
      request.headers['Authorization'] = 'Bearer $newAccess';
      final response = await _dio.fetch<dynamic>(request);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  bool _shouldAttemptRefresh(DioException err) {
    if (err.response?.statusCode != 401) {
      return false;
    }

    final path = err.requestOptions.path;
    if (path.contains('/Users/refresh') || path.contains('/Users/login')) {
      return false;
    }

    return true;
  }
}
