// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_reverse_dns_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfReverseDnsDto
_$ErrorExceptionResultOfReverseDnsDtoFromJson(Map<String, dynamic> json) =>
    ErrorExceptionResultOfReverseDnsDto(
      isSuccess: json['isSuccess'] as bool?,
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
      data: json['data'] == null
          ? null
          : ReverseDnsDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorExceptionResultOfReverseDnsDtoToJson(
  ErrorExceptionResultOfReverseDnsDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
