import 'package:dio/dio.dart';

import '../../core/network/api_result.dart';

class ContactSubmissionResult {
  const ContactSubmissionResult({
    required this.ticketId,
    required this.emailSent,
  });

  final int ticketId;
  final bool emailSent;

  factory ContactSubmissionResult.fromJson(Map<String, dynamic> json) {
    return ContactSubmissionResult(
      ticketId: json['ticketId'] as int? ?? 0,
      emailSent: json['emailSent'] as bool? ?? false,
    );
  }
}

class ContactRemoteDataSource {
  ContactRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ApiResult<ContactSubmissionResult>> submit({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/api/v1/Contact',
        data: {
          'name': name,
          'email': email,
          'subject': subject,
          'message': message,
        },
      );

      final envelope = response.data;
      if (envelope == null || envelope['isSuccess'] != true) {
        return ApiResult.fail(
          envelope?['errorMessage']?.toString() ?? 'Submit failed',
        );
      }

      final data = envelope['data'] as Map<String, dynamic>?;
      if (data == null) {
        return ApiResult.fail('Invalid response');
      }

      return ApiResult.ok(ContactSubmissionResult.fromJson(data));
    } on DioException catch (error) {
      final data = error.response?.data;
      if (data is Map && data['errorMessage'] != null) {
        return ApiResult.fail(data['errorMessage'].toString());
      }

      return ApiResult.fail(error.message ?? 'Submit failed');
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }
}
