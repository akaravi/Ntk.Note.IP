import '../../core/network/api_result.dart';
import '../repositories/ip_lookup_repository.dart';

class GetMyIpPlainUseCase {
  const GetMyIpPlainUseCase(this._repository);

  final IpLookupRepository _repository;

  Future<ApiResult<String>> call() => _repository.getMyIpPlain();
}
