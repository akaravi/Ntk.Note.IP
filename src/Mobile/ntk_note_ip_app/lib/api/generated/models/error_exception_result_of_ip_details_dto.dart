// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'ip_details_dto.dart';

part 'error_exception_result_of_ip_details_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfIpDetailsDto {
  const ErrorExceptionResultOfIpDetailsDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfIpDetailsDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfIpDetailsDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final IpDetailsDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfIpDetailsDtoToJson(this);
}
