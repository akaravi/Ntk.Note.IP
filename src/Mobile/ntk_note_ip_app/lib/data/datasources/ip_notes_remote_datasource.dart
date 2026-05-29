import '../../api/generated/clients/ipnote_client.dart';
import '../../api/generated/models/add_ip_note_command.dart';
import '../../api/generated/models/update_ip_note_command.dart';
import '../../core/network/api_result.dart';
import '../../core/network/openapi_envelope.dart';

class IpNotesRemoteDataSource {
  IpNotesRemoteDataSource(this._client);

  final IpnoteClient _client;

  Future<ApiResult<List<Map<String, dynamic>>>> getList() async {
    try {
      final envelope = await _client.getListIpNotes();
      if (envelope.isSuccess != true) {
        return ApiResult.fail(envelope.errorMessage ?? 'Request failed');
      }

      final items =
          envelope.data?.map((dto) => dto.toJson()).toList() ?? <Map<String, dynamic>>[];
      return ApiResult.ok(items);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<int>> add(Map<String, dynamic> body) async {
    try {
      final envelope = await _client.addIpNote(
        body: AddIpNoteCommand.fromJson(body.cast<String, Object?>()),
      );
      final result = OpenApiEnvelope.mapData(
        isSuccess: envelope.isSuccess,
        errorMessage: envelope.errorMessage,
        data: envelope.data,
      );
      if (!result.isSuccess) {
        return ApiResult.fail(result.errorMessage ?? 'Request failed');
      }

      final id = result.data;
      if (id is int) {
        return ApiResult.ok(id);
      }

      return ApiResult.ok(int.tryParse(id?.toString() ?? '') ?? 0);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<void>> update({
    required int id,
    required String address,
    String? title,
    String? body,
    String? tags,
  }) async {
    try {
      await _client.updateIpNote(
        id: id,
        body: UpdateIpNoteCommand(
          id: id,
          address: address,
          title: title,
          body: body,
          tags: tags,
        ),
      );
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<void>> delete(int id) async {
    try {
      await _client.deleteIpNote(id: id);
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }
}
