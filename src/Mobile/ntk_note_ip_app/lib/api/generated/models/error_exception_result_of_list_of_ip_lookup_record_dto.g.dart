// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_list_of_ip_lookup_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfListOfIpLookupRecordDto
_$ErrorExceptionResultOfListOfIpLookupRecordDtoFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfListOfIpLookupRecordDto(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => IpLookupRecordDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ErrorExceptionResultOfListOfIpLookupRecordDtoToJson(
  ErrorExceptionResultOfListOfIpLookupRecordDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
