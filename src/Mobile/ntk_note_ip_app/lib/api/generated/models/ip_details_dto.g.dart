// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpDetailsDto _$IpDetailsDtoFromJson(Map<String, dynamic> json) => IpDetailsDto(
  address: json['address'] as String?,
  scope: (json['scope'] as num?)?.toInt(),
  isIPv6: json['isIPv6'] as bool?,
  geo: json['geo'] == null
      ? null
      : GeoLocationDto.fromJson(json['geo'] as Map<String, dynamic>),
  asn: json['asn'] == null
      ? null
      : AsnInfoDto.fromJson(json['asn'] as Map<String, dynamic>),
  isp: json['isp'] as String?,
  reverseDns: json['reverseDns'] as String?,
);

Map<String, dynamic> _$IpDetailsDtoToJson(IpDetailsDto instance) =>
    <String, dynamic>{
      'address': instance.address,
      'scope': instance.scope,
      'isIPv6': instance.isIPv6,
      'geo': instance.geo,
      'asn': instance.asn,
      'isp': instance.isp,
      'reverseDns': instance.reverseDns,
    };
