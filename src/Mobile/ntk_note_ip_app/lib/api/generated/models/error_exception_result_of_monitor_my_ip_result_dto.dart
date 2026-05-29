// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'monitor_my_ip_result_dto.dart';

part 'error_exception_result_of_monitor_my_ip_result_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfMonitorMyIpResultDto {
  const ErrorExceptionResultOfMonitorMyIpResultDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfMonitorMyIpResultDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfMonitorMyIpResultDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final MonitorMyIpResultDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfMonitorMyIpResultDtoToJson(this);
}
