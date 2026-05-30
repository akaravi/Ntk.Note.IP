import 'package:dio/dio.dart';

import '../../api/generated/clients/ipnote_client.dart';
import '../../api/generated/models/login_request.dart';
import '../../api/generated/models/register_request.dart';
import '../../api/generated/models/refresh_request.dart';
import '../../core/auth/auth_token_mapper.dart';
import '../../core/auth/auth_tokens.dart';
import '../../core/config/app_config.dart';
import '../../core/network/api_result.dart';
import 'auth_remote_port.dart';

class AuthRemoteDataSource implements AuthRemotePort {
  AuthRemoteDataSource(this._client);

  final IpnoteClient _client;

  @override
  Future<ApiResult<void>> register({
    required String email,
    required String password,
  }) async {
    try {
      await _client.postApiV1UsersRegister(
        body: RegisterRequest(email: email, password: password),
      );
      return ApiResult.ok(null);
    } on DioException catch (error) {
      return _failFromDio<void>(error, 'Registration failed');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  @override
  Future<ApiResult<AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.postApiV1UsersLogin(
        body: LoginRequest(email: email, password: password),
        useCookies: false,
      );

      final tokens = authTokensFromAccessTokenResponse(response);
      if (!tokens.isValid) {
        return ApiResult.fail('Invalid token response');
      }

      return ApiResult.ok(tokens);
    } on DioException catch (error) {
      return _failFromDio(error, 'Login failed');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  @override
  Future<ApiResult<AuthTokens>> refresh({
    required String refreshToken,
  }) async {
    try {
      final response = await _client.postApiV1UsersRefresh(
        body: RefreshRequest(refreshToken: refreshToken),
      );

      final tokens = authTokensFromAccessTokenResponse(response);
      if (!tokens.isValid) {
        return ApiResult.fail('Invalid token response');
      }

      return ApiResult.ok(tokens);
    } on DioException catch (error) {
      return _failFromDio(error, 'Refresh failed');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  ApiResult<T> _failFromDio<T>(DioException error, String fallback) {
    final status = error.response?.statusCode;
    final data = error.response?.data;

    if (data is Map) {
      final detail = data['detail'] ?? data['title'] ?? data['errorMessage'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        return ApiResult.fail(detail.toString());
      }
    }

    if (status == 401) {
      return ApiResult.fail(fallback);
    }

    if (status != null && status >= 500) {
      return ApiResult.fail('Server error ($status). Try again later.');
    }

    final message = error.message ?? '';
    if (message.contains('status code of 500') ||
        message.contains('status code of 502') ||
        message.contains('status code of 503')) {
      return ApiResult.fail('Server error. Try again later.');
    }

    if (message.contains('Failed host lookup') ||
        message.contains('Connection refused') ||
        message.contains('connection timeout')) {
      return ApiResult.fail(
        'Cannot reach API (${AppConfig.current.apiBaseUrl}). Check network or app build URL.',
      );
    }

    return ApiResult.fail(fallback);
  }
}
