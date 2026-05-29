// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_monitor_my_ip_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfMonitorMyIpResultDto
_$ErrorExceptionResultOfMonitorMyIpResultDtoFromJson(
  Map<String, dynamic> json,
) => ErrorExceptionResultOfMonitorMyIpResultDto(
  isSuccess: json['isSuccess'] as bool?,
  errorMessage: json['errorMessage'] as String?,
  errorCode: json['errorCode'] as String?,
  data: json['data'] == null
      ? null
      : MonitorMyIpResultDto.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ErrorExceptionResultOfMonitorMyIpResultDtoToJson(
  ErrorExceptionResultOfMonitorMyIpResultDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
