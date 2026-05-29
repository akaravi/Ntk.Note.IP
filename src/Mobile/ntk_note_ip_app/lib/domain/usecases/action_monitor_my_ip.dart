import '../../core/network/api_result.dart';
import '../entities/monitor_my_ip_result.dart';
import '../repositories/ip_lookup_repository.dart';

class ActionMonitorMyIpUseCase {
  const ActionMonitorMyIpUseCase(this._repository);

  final IpLookupRepository _repository;

  Future<ApiResult<MonitorMyIpResult>> call() => _repository.actionMonitorMyIp();
}
