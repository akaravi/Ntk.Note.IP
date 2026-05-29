import '../../core/network/api_result.dart';
import '../entities/ip_details.dart';
import '../repositories/ip_lookup_repository.dart';

class GetIpDetailsUseCase {
  const GetIpDetailsUseCase(this._repository);

  final IpLookupRepository _repository;

  Future<ApiResult<IpDetails>> call(String address) =>
      _repository.getIpDetails(address);
}
