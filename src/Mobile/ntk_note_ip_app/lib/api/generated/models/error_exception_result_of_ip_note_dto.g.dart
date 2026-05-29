// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_ip_note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfIpNoteDto _$ErrorExceptionResultOfIpNoteDtoFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfIpNoteDto(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: json['data'] == null
      ? null
      : IpNoteDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ErrorExceptionResultOfIpNoteDtoToJson(
  ErrorExceptionResultOfIpNoteDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
