import 'api_result.dart';

/// Maps generated OpenAPI envelope DTOs to [ApiResult].
class OpenApiEnvelope {
  const OpenApiEnvelope._();

  static ApiResult<T> mapData<T>({
    required bool? isSuccess,
    required String? errorMessage,
    required T? data,
  }) {
    if (isSuccess == true && data != null) {
      return ApiResult.ok(data);
    }

    return ApiResult.fail(errorMessage ?? 'Request failed');
  }

  static ApiResult<void> mapVoid({
    required bool? isSuccess,
    required String? errorMessage,
  }) {
    if (isSuccess == true) {
      return ApiResult.ok(null);
    }

    return ApiResult.fail(errorMessage ?? 'Request failed');
  }
}
