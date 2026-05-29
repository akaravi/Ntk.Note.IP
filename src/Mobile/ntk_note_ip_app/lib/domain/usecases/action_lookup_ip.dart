import '../../core/network/api_result.dart';
import '../repositories/ip_lookup_repository.dart';

class ActionLookupIpUseCase {
  const ActionLookupIpUseCase(this._repository);

  final IpLookupRepository _repository;

  Future<ApiResult<void>> call(String address) =>
      _repository.actionLookup(address);
}
