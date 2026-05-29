// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_list_of_ip_note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfListOfIpNoteDto
_$ErrorExceptionResultOfListOfIpNoteDtoFromJson(Map<String, dynamic> json) =>
    ErrorExceptionResultOfListOfIpNoteDto(
      isSuccess: json['isSuccess'] as bool?,
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => IpNoteDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ErrorExceptionResultOfListOfIpNoteDtoToJson(
  ErrorExceptionResultOfListOfIpNoteDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
