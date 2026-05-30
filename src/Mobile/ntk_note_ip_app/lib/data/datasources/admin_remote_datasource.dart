import 'package:dio/dio.dart';

import '../../core/network/api_result.dart';
import '../../domain/entities/admin_models.dart';

class AdminRemoteDataSource {
  AdminRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ApiResult<AdminAccess>> getAccess() {
    return _getOne('/api/v1/AdminAccess/GetOne', AdminAccess.fromJson);
  }

  Future<ApiResult<AdminDashboardStats>> getDashboard() {
    return _getOne('/api/v1/AdminDashboard/GetOne', AdminDashboardStats.fromJson);
  }

  Future<ApiResult<List<AdminUser>>> getUsers() {
    return _getList('/api/v1/AdminUsers/GetList', AdminUser.fromJson);
  }

  Future<ApiResult<List<AdminRole>>> getRoles() {
    return _getList('/api/v1/AdminRoles/GetList', AdminRole.fromJson);
  }

  Future<ApiResult<List<AdminPermissionCatalogItem>>> getPermissionCatalog() {
    return _getList(
      '/api/v1/AdminRoles/GetListPermissions',
      AdminPermissionCatalogItem.fromJson,
    );
  }

  Future<ApiResult<void>> updateRolePermissions(
    String roleId,
    List<String> permissions,
  ) async {
    try {
      await _dio.post<void>(
        '/api/v1/AdminRoles/UpdatePermissions',
        data: {'roleId': roleId, 'permissions': permissions},
      );
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<void>> setUserRoles(String userId, List<String> roles) async {
    try {
      await _dio.post<void>(
        '/api/v1/AdminUsers/ActionSetRoles',
        data: {'userId': userId, 'roles': roles},
      );
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<AdminIpNoteItem>>> getIpNotes({String? search}) {
    return _getList(
      '/api/v1/AdminIpNotes/GetList',
      AdminIpNoteItem.fromJson,
      query: search != null && search.trim().isNotEmpty
          ? {'search': search.trim()}
          : null,
    );
  }

  Future<ApiResult<void>> deleteIpNote(int id) async {
    try {
      await _dio.delete<void>('/api/v1/AdminIpNotes/$id');
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<AdminIpLookupItem>>> getIpLookups({String? search}) {
    return _getList(
      '/api/v1/AdminIpLookupRecords/GetList',
      AdminIpLookupItem.fromJson,
      query: search != null && search.trim().isNotEmpty
          ? {'search': search.trim()}
          : null,
    );
  }

  Future<ApiResult<void>> deleteIpLookup(int id) async {
    try {
      await _dio.delete<void>('/api/v1/AdminIpLookupRecords/$id');
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<AdminPushDevice>>> getPushDevices() {
    return _getList('/api/v1/AdminPushDevices/GetList', AdminPushDevice.fromJson);
  }

  Future<ApiResult<void>> deletePushDevice(int id) async {
    try {
      await _dio.delete<void>('/api/v1/AdminPushDevices/$id');
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<AdminOutboxMessage>>> getOutbox({bool pendingOnly = false}) {
    return _getList(
      '/api/v1/AdminOutbox/GetList',
      AdminOutboxMessage.fromJson,
      query: {'pendingOnly': pendingOnly.toString()},
    );
  }

  Future<ApiResult<List<AdminSupportTicket>>> getSupportTickets({bool openOnly = false}) {
    return _getList(
      '/api/v1/AdminSupportTickets/GetList',
      AdminSupportTicket.fromJson,
      query: {'openOnly': openOnly.toString()},
    );
  }

  Future<ApiResult<void>> updateSupportTicketStatus(int id, int status) async {
    try {
      await _dio.post<void>(
        '/api/v1/AdminSupportTickets/ActionUpdateStatus',
        data: {'id': id, 'status': status},
      );
      return ApiResult.ok(null);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<T>> _getOne<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      return _unwrapObject(response.data, fromJson);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<T>>> _getList<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, String>? query,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      final envelope = response.data;
      if (envelope == null) {
        return ApiResult.fail('Empty response');
      }

      if (envelope['isSuccess'] != true) {
        return ApiResult.fail(envelope['errorMessage'] as String? ?? 'Request failed');
      }

      final data = envelope['data'];
      if (data is! List) {
        return ApiResult.ok(const []);
      }

      return ApiResult.ok(
        data.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  ApiResult<T> _unwrapObject<T>(
    Map<String, dynamic>? envelope,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (envelope == null) {
      return ApiResult.fail('Empty response');
    }

    if (envelope['isSuccess'] != true) {
      return ApiResult.fail(envelope['errorMessage'] as String? ?? 'Request failed');
    }

    final data = envelope['data'];
    if (data is! Map<String, dynamic>) {
      return ApiResult.fail('Invalid response data');
    }

    return ApiResult.ok(fromJson(data));
  }
}
