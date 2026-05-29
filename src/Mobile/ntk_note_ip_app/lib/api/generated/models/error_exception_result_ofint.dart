// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'error_exception_result_ofint.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfint {
  const ErrorExceptionResultOfint({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfint.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfintFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final dynamic data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfintToJson(this);
}
