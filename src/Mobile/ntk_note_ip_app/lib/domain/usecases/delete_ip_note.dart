import '../../core/network/api_result.dart';
import '../repositories/ip_notes_repository.dart';

class DeleteIpNoteUseCase {
  const DeleteIpNoteUseCase(this._repository);

  final IpNotesRepository _repository;

  Future<ApiResult<void>> call(int id) => _repository.delete(id);
}
