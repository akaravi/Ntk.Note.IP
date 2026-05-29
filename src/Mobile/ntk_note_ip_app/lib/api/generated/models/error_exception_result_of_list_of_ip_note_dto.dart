// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'ip_note_dto.dart';

part 'error_exception_result_of_list_of_ip_note_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfListOfIpNoteDto {
  const ErrorExceptionResultOfListOfIpNoteDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfListOfIpNoteDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfListOfIpNoteDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final List<IpNoteDto>? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfListOfIpNoteDtoToJson(this);
}
