import '../../api/openapi_mappers.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/ip_details.dart';
import '../../domain/entities/ip_lookup_record.dart';
import '../../domain/entities/monitor_my_ip_result.dart';
import '../../domain/entities/my_ip.dart';
import '../../domain/repositories/ip_lookup_repository.dart';
import '../datasources/ip_lookup_remote_datasource.dart';

class IpLookupRepositoryImpl implements IpLookupRepository {
  IpLookupRepositoryImpl(this._remote);

  final IpLookupRemoteDataSource _remote;

  @override
  Future<ApiResult<MyIp>> getMyIp() async {
    final result = await _remote.getMyIp();
    if (!result.isSuccess || result.data == null) {
      return ApiResult.fail(result.errorMessage ?? 'Request failed');
    }

    return ApiResult.ok(OpenApiMappers.toMyIp(result.data!));
  }

  @override
  Future<ApiResult<String>> getMyIpPlain() async {
    return _remote.getMyIpPlain();
  }

  @override
  Future<ApiResult<IpDetails>> getIpDetails(String address) async {
    final result = await _remote.getIpDetails(address);
    if (!result.isSuccess || result.data == null) {
      return ApiResult.fail(result.errorMessage ?? 'Request failed');
    }

    return ApiResult.ok(OpenApiMappers.toIpDetails(result.data!));
  }

  @override
  Future<ApiResult<void>> actionLookup(String address) async {
    final result = await _remote.actionLookup(address);
    if (!result.isSuccess) {
      return ApiResult.fail(result.errorMessage ?? 'Request failed');
    }

    return ApiResult.ok(null);
  }

  @override
  Future<ApiResult<MonitorMyIpResult>> actionMonitorMyIp() async {
    final result = await _remote.actionMonitorMyIp();
    if (!result.isSuccess || result.data == null) {
      return ApiResult.fail(result.errorMessage ?? 'Request failed');
    }

    return ApiResult.ok(OpenApiMappers.toMonitorMyIpResult(result.data!));
  }

  @override
  Future<ApiResult<List<IpLookupRecord>>> getListIpLookupRecords() async {
    final result = await _remote.getListIpLookupRecords();
    if (!result.isSuccess || result.data == null) {
      return ApiResult.fail(result.errorMessage ?? 'Request failed');
    }

    return ApiResult.ok(
      result.data!.map(OpenApiMappers.toIpLookupRecord).toList(),
    );
  }
}
