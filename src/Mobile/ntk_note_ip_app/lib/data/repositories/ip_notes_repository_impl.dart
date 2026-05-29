import '../../api/openapi_mappers.dart';
import '../../domain/entities/ip_note_add_snapshot.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/ip_note.dart';
import '../../domain/repositories/ip_notes_repository.dart';
import '../datasources/ip_notes_remote_datasource.dart';

class IpNotesRepositoryImpl implements IpNotesRepository {
  IpNotesRepositoryImpl(this._remote);

  final IpNotesRemoteDataSource _remote;

  @override
  Future<ApiResult<List<IpNote>>> getList() async {
    final result = await _remote.getList();
    if (!result.isSuccess || result.data == null) {
      return ApiResult.fail(result.errorMessage ?? 'Request failed');
    }

    return ApiResult.ok(result.data!.map(OpenApiMappers.ipNoteFromJson).toList());
  }

  @override
  Future<ApiResult<int>> add({
    required String address,
    String? title,
    String? body,
    String? tags,
    IpNoteAddSnapshot? snapshot,
  }) {
    return _remote.add({
      'address': address,
      if (title != null && title.isNotEmpty) 'title': title,
      if (body != null && body.isNotEmpty) 'body': body,
      if (tags != null && tags.isNotEmpty) 'tags': tags,
      if (snapshot != null) ...snapshot.toJson(),
    });
  }

  @override
  Future<ApiResult<void>> update({
    required int id,
    required String address,
    String? title,
    String? body,
    String? tags,
  }) =>
      _remote.update(
        id: id,
        address: address,
        title: title,
        body: body,
        tags: tags,
      );

  @override
  Future<ApiResult<void>> delete(int id) => _remote.delete(id);
}
