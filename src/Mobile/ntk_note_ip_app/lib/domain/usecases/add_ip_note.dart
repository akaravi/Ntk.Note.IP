import '../../core/network/api_result.dart';
import '../entities/ip_note_add_snapshot.dart';
import '../repositories/ip_notes_repository.dart';

class AddIpNoteUseCase {
  const AddIpNoteUseCase(this._repository);

  final IpNotesRepository _repository;

  Future<ApiResult<int>> call({
    required String address,
    String? title,
    String? body,
    String? tags,
    IpNoteAddSnapshot? snapshot,
  }) =>
      _repository.add(
        address: address,
        title: title,
        body: body,
        tags: tags,
        snapshot: snapshot,
      );
}
