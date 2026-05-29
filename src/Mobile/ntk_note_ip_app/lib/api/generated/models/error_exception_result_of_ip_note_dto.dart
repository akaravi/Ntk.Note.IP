// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'ip_note_dto.dart';

part 'error_exception_result_of_ip_note_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfIpNoteDto {
  const ErrorExceptionResultOfIpNoteDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfIpNoteDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfIpNoteDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final IpNoteDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfIpNoteDtoToJson(this);
}
