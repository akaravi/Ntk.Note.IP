// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'ip_lookup_record_dto.dart';

part 'error_exception_result_of_ip_lookup_record_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfIpLookupRecordDto {
  const ErrorExceptionResultOfIpLookupRecordDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfIpLookupRecordDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfIpLookupRecordDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final IpLookupRecordDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfIpLookupRecordDtoToJson(this);
}
