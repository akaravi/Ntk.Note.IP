import '../../core/network/api_result.dart';
import '../entities/ip_note.dart';
import '../entities/ip_note_add_snapshot.dart';

abstract interface class IpNotesRepository {
  Future<ApiResult<List<IpNote>>> getList();

  Future<ApiResult<int>> add({
    required String address,
    String? title,
    String? body,
    String? tags,
    IpNoteAddSnapshot? snapshot,
  });

  Future<ApiResult<void>> update({
    required int id,
    required String address,
    String? title,
    String? body,
    String? tags,
  });

  Future<ApiResult<void>> delete(int id);
}
