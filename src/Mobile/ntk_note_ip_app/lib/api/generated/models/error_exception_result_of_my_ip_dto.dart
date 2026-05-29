// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'my_ip_dto.dart';

part 'error_exception_result_of_my_ip_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfMyIpDto {
  const ErrorExceptionResultOfMyIpDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfMyIpDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfMyIpDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final MyIpDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfMyIpDtoToJson(this);
}
