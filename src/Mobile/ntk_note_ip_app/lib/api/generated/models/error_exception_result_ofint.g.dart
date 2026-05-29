// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_ofint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfint _$ErrorExceptionResultOfintFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfint(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: json['data'],
);

Map<String, dynamic> _$ErrorExceptionResultOfintToJson(
  ErrorExceptionResultOfint instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
