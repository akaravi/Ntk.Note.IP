// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_my_ip_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfMyIpDto _$ErrorExceptionResultOfMyIpDtoFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfMyIpDto(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: json['data'] == null
      ? null
      : MyIpDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ErrorExceptionResultOfMyIpDtoToJson(
  ErrorExceptionResultOfMyIpDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
