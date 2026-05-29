import '../../core/network/api_result.dart';
import '../entities/ip_lookup_record.dart';
import '../repositories/ip_lookup_repository.dart';

class GetListIpLookupRecordsUseCase {
  const GetListIpLookupRecordsUseCase(this._repository);

  final IpLookupRepository _repository;

  Future<ApiResult<List<IpLookupRecord>>> call() =>
      _repository.getListIpLookupRecords();
}
