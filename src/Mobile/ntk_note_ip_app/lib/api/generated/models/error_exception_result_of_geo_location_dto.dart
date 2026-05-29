// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'geo_location_dto.dart';

part 'error_exception_result_of_geo_location_dto.g.dart';

@JsonSerializable()
class ErrorExceptionResultOfGeoLocationDto {
  const ErrorExceptionResultOfGeoLocationDto({
    this.isSuccess,
    this.errorMessage,
    this.errorCode,
    this.data,
  });
  
  factory ErrorExceptionResultOfGeoLocationDto.fromJson(Map<String, Object?> json) => _$ErrorExceptionResultOfGeoLocationDtoFromJson(json);
  
  final bool? isSuccess;
  final String? errorMessage;
  final String? errorCode;
  final GeoLocationDto? data;

  Map<String, Object?> toJson() => _$ErrorExceptionResultOfGeoLocationDtoToJson(this);
}
