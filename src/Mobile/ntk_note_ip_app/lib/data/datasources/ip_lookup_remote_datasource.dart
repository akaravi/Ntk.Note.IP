import '../../api/generated/clients/ipnote_client.dart';
import '../../api/generated/models/action_lookup_ip_command.dart';
import '../../core/network/api_result.dart';
import '../../core/network/openapi_envelope.dart';

class IpLookupRemoteDataSource {
  IpLookupRemoteDataSource(this._client);

  final IpnoteClient _client;

  Future<ApiResult<Map<String, dynamic>>> getMyIp() async {
    try {
      final envelope = await _client.getMyIp();
      final result = OpenApiEnvelope.mapData(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data?.toJson(),
      );
      if (!result.isSuccess) {
        return ApiResult.fail(result.errorMessage ?? 'Request failed');
      }

      return ApiResult.ok(result.data!);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<Map<String, dynamic>>> getIpDetails(String address) async {
    try {
      final envelope = await _client.getIpDetails(address: address);
      final result = OpenApiEnvelope.mapData(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data?.toJson(),
      );
      if (!result.isSuccess) {
        return ApiResult.fail(result.errorMessage ?? 'Request failed');
      }

      return ApiResult.ok(result.data!);
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

  Future<ApiResult<Map<String, dynamic>>> actionMonitorMyIp() async {
    try {
      final envelope = await _client.actionMonitorMyIp();
      final result = OpenApiEnvelope.mapData(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data?.toJson(),
      );
      if (!result.isSuccess) {
        return ApiResult.fail(result.errorMessage ?? 'Request failed');
      }

      return ApiResult.ok(result.data!);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<Map<String, dynamic>>>> getListIpLookupRecords() async {
    try {
      final envelope = await _client.getListIpLookupRecords();
      if (envelope.isSuccess != true) {
        return ApiResult.fail(envelope.errorMessage ?? 'Request failed');
      }

      final items = envelope.data
              ?.map((dto) => dto.toJson())
              .toList() ??
          <Map<String, dynamic>>[];
      return ApiResult.ok(items);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }
}
