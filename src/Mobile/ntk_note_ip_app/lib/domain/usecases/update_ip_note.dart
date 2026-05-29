import '../../core/network/api_result.dart';
import '../repositories/ip_notes_repository.dart';

class UpdateIpNoteUseCase {
  const UpdateIpNoteUseCase(this._repository);

  final IpNotesRepository _repository;

  Future<ApiResult<void>> call({
    required int id,
    required String address,
    String? title,
    String? body,
    String? tags,
  }) =>
      _repository.update(
        id: id,
        address: address,
        title: title,
        body: body,
        tags: tags,
      );
}
