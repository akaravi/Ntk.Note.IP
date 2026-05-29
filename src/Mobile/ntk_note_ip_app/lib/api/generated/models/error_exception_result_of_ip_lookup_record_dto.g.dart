// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_ip_lookup_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfIpLookupRecordDto
_$ErrorExceptionResultOfIpLookupRecordDtoFromJson(Map<String, dynamic> json) =>
    ErrorExceptionResultOfIpLookupRecordDto(
      isSuccess: json['isSuccess'] as bool?,
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
      data: json['data'] == null
          ? null
          : IpLookupRecordDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorExceptionResultOfIpLookupRecordDtoToJson(
  ErrorExceptionResultOfIpLookupRecordDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
