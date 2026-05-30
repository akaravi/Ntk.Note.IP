import 'package:dio/dio.dart';

import '../../api/generated/clients/ipnote_client.dart';
import '../../api/generated/models/action_lookup_ip_command.dart';
import '../../api/generated/models/ip_details_dto.dart';
import '../../api/generated/models/ip_lookup_record_dto.dart';
import '../../api/generated/models/monitor_my_ip_result_dto.dart';
import '../../api/generated/models/my_ip_dto.dart';
import '../../core/api/api_routes.dart';
import '../../core/network/api_result.dart';
import '../../core/network/openapi_envelope.dart';

class IpLookupRemoteDataSource {
  IpLookupRemoteDataSource(this._client, this._dio);

  final IpnoteClient _client;
  final Dio _dio;
  Future<ApiResult<MyIpDto>> getMyIp() async {
    try {
      final envelope = await _client.getMyIp();
      return _mapDto(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data,
      );
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<String>> getMyIpPlain() async {
    try {
      final response = await _dio.get<String>(
        ApiRoutes.myIpShortPath,
        options: Options(responseType: ResponseType.plain),
      );
      final text = response.data?.trim();
      if (text == null || text.isEmpty) {
        return ApiResult.fail('Empty response');
      }

      return ApiResult.ok(text);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<IpDetailsDto>> getIpDetails(String address) async {
    try {
      final envelope = await _client.getIpDetails(address: address);
      return _mapDto(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data,
      );
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<void>> actionLookup(String address) async {
    try {
      final envelope = await _client.actionLookup(
        body: ActionLookupIpCommand(address: address),
      );
      return OpenApiEnvelope.mapVoid(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
      );
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<MonitorMyIpResultDto>> actionMonitorMyIp() async {
    try {
      final envelope = await _client.actionMonitorMyIp();
      return _mapDto(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data,
      );
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<IpLookupRecordDto>>> getListIpLookupRecords() async {
    try {
      final envelope = await _client.getListIpLookupRecords();
      if (envelope.isSuccess != true) {
        return ApiResult.fail(envelope.errorMessage ?? 'Request failed');
      }

      return ApiResult.ok(envelope.data ?? const []);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  ApiResult<T> _mapDto<T>({
    required bool? isSuccess,
    required String? errorMessage,
    required T? data,
  }) {
    if (isSuccess == true && data != null) {
      return ApiResult.ok(data);
    }

    return ApiResult.fail(errorMessage ?? 'Request failed');
  }
}
