// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'geo_location_dto.g.dart';

@JsonSerializable()
class GeoLocationDto {
  const GeoLocationDto({
    this.latitude,
    this.longitude,
    this.countryCode,
    this.country,
    this.region,
    this.city,
    this.timezone,
  });
  
  factory GeoLocationDto.fromJson(Map<String, Object?> json) => _$GeoLocationDtoFromJson(json);
  
  final dynamic latitude;
  final dynamic longitude;
  final String? countryCode;
  final String? country;
  final String? region;
  final String? city;
  final String? timezone;

  Map<String, Object?> toJson() => _$GeoLocationDtoToJson(this);
}
