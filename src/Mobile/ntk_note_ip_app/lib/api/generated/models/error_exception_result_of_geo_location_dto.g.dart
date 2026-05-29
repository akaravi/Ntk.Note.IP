// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_exception_result_of_geo_location_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorExceptionResultOfGeoLocationDto
_$ErrorExceptionResultOfGeoLocationDtoFromJson(Map<String, dynamic> json) =>
    ErrorExceptionResultOfGeoLocationDto(
      isSuccess: json['isSuccess'] as bool?,
      errorMessage: json['errorMessage'] as String?,
      errorCode: json['errorCode'] as String?,
      data: json['data'] == null
          ? null
          : GeoLocationDto.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ErrorExceptionResultOfGeoLocationDtoToJson(
  ErrorExceptionResultOfGeoLocationDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'errorMessage': instance.errorMessage,
  'errorCode': instance.errorCode,
  'data': instance.data,
};
