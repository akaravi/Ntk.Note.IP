import 'package:dio/dio.dart';

import '../auth/auth_token_refresh_interceptor.dart';
import '../config/app_config.dart';
import 'api_result.dart';

typedef AccessTokenProvider = String? Function();

class ApiClient {
  ApiClient({
    Dio? dio,
    AccessTokenProvider? accessTokenProvider,
    Future<String?> Function()? onRefreshAccessToken,
  }) : _dio = dio ?? Dio(_baseOptions) {
    if (accessTokenProvider != null) {
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            final token = accessTokenProvider();
            if (token != null && token.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            handler.next(options);
          },
        ),
      );
    }

    if (onRefreshAccessToken != null) {
      _dio.interceptors.add(
        AuthTokenRefreshInterceptor(
          dio: _dio,
          onRefreshAccessToken: onRefreshAccessToken,
        ),
      );
    }
  }

  static final BaseOptions _baseOptions = BaseOptions(
    baseUrl: AppConfig.current.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
    headers: {'Accept': 'application/json'},
  );

  final Dio _dio;

  Dio get dio => _dio;

  Future<ApiResult<T>> postJson<T>(
    String path, {
    Object? data,
    required T Function(Map<String, dynamic> json) parse,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      final body = response.data;
      if (body == null) {
        return ApiResult.fail('Empty response');
      }

      return ApiResult.ok(parse(body));
    } on DioException catch (error) {
      final message = error.response?.data?.toString() ?? error.message;
      return ApiResult.fail(message ?? 'Network error');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<T>> postData<T>(
    String path, {
    Object? data,
    required T Function(Object? json) parse,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: data);
      final body = response.data;
      if (body == null) {
        return ApiResult.fail('Empty response');
      }

      final isSuccess = body['isSuccess'] == true;
      if (!isSuccess) {
        return ApiResult.fail(
          body['errorMessage']?.toString() ?? 'Request failed',
        );
      }

      return ApiResult.ok(parse(body['data']));
    } on DioException catch (error) {
      return ApiResult.fail(error.message ?? 'Network error');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<T>> getData<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Object? json) parse,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      final body = response.data;
      if (body == null) {
        return ApiResult.fail('Empty response');
      }

      final isSuccess = body['isSuccess'] == true;
      if (!isSuccess) {
        return ApiResult.fail(
          body['errorMessage']?.toString() ?? 'Request failed',
        );
      }

      return ApiResult.ok(parse(body['data']));
    } on DioException catch (error) {
      return ApiResult.fail(error.message ?? 'Network error');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }
}
