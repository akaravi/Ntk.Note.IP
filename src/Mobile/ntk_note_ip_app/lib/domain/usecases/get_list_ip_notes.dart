import '../../core/network/api_result.dart';
import '../entities/ip_note.dart';
import '../repositories/ip_notes_repository.dart';

class GetListIpNotesUseCase {
  const GetListIpNotesUseCase(this._repository);

  final IpNotesRepository _repository;

  Future<ApiResult<List<IpNote>>> call() => _repository.getList();
}
