import 'package:dio/dio.dart';

import '../../api/generated/clients/ipnote_client.dart';
import '../../api/generated/models/login_request.dart';
import '../../api/generated/models/register_request.dart';
import '../../api/generated/models/refresh_request.dart';
import '../../core/auth/auth_token_mapper.dart';
import '../../core/auth/auth_tokens.dart';
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
    final data = error.response?.data;
    if (data is Map && data['detail'] != null) {
      return ApiResult.fail(data['detail'].toString());
    }

    if (data is Map && data['title'] != null) {
      return ApiResult.fail(data['title'].toString());
    }

    return ApiResult.fail(error.message ?? fallback);
  }
}
