// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_asn_info_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfAsnInfoDto _$ErrorExceptionResultOfAsnInfoDtoFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfAsnInfoDto(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: json['data'] == null
      ? null
      : AsnInfoDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ErrorExceptionResultOfAsnInfoDtoToJson(
  ErrorExceptionResultOfAsnInfoDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
