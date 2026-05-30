import '../../core/network/api_result.dart';
import '../entities/ip_details.dart';
import '../entities/ip_lookup_record.dart';
import '../entities/monitor_my_ip_result.dart';
import '../entities/my_ip.dart';

abstract interface class IpLookupRepository {
  Future<ApiResult<MyIp>> getMyIp();

  Future<ApiResult<String>> getMyIpPlain();

  Future<ApiResult<IpDetails>> getIpDetails(String address);

  Future<ApiResult<void>> actionLookup(String address);

  Future<ApiResult<List<IpLookupRecord>>> getListIpLookupRecords();

  Future<ApiResult<MonitorMyIpResult>> actionMonitorMyIp();
}
