// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_ip_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfIpDetailsDto _$ErrorExceptionResultOfIpDetailsDtoFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfIpDetailsDto(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: json['data'] == null
      ? null
      : IpDetailsDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ErrorExceptionResultOfIpDetailsDtoToJson(
  ErrorExceptionResultOfIpDetailsDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
