// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'reverse_dns_dto.dart';

part 'error_exception_result_of_reverse_dns_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfReverseDnsDto {
  const ErrorExceptionResultOfReverseDnsDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfReverseDnsDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfReverseDnsDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final ReverseDnsDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfReverseDnsDtoToJson(this);
}
