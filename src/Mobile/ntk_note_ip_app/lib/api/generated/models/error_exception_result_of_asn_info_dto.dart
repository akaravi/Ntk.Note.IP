// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'asn_info_dto.dart';

part 'error_exception_result_of_asn_info_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfAsnInfoDto {
  const ErrorExceptionResultOfAsnInfoDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfAsnInfoDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfAsnInfoDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final AsnInfoDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfAsnInfoDtoToJson(this);
}
