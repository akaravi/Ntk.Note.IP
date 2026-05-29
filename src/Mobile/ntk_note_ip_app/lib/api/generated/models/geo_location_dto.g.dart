// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoLocationDto _$GeoLocationDtoFromJson(Map<String, dynamic> json) =>
    GeoLocationDto(
      latitude: json['latitude'],
      longitude: json['longitude'],
      countryCode: json['countryCode'] as String?,
      country: json['country'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      timezone: json['timezone'] as String?,
    );

Map<String, dynamic> _$GeoLocationDtoToJson(GeoLocationDto instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'countryCode': instance.countryCode,
      'country': instance.country,
      'region': instance.region,
      'city': instance.city,
      'timezone': instance.timezone,
    };
