import '../../core/network/api_result.dart';
import '../entities/my_ip.dart';
import '../repositories/ip_lookup_repository.dart';

class GetMyIpUseCase {
  const GetMyIpUseCase(this._repository);

  final IpLookupRepository _repository;

  Future<ApiResult<MyIp>> call() => _repository.getMyIp();
}
