// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_lookup_record_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpLookupRecordDto _$IpLookupRecordDtoFromJson(Map<String, dynamic> json) =>
    IpLookupRecordDto(
      id: json['id'],
      address: json['address'] as String?,
      countryCode: json['countryCode'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      asn: json['asn'] as String?,
      isp: json['isp'] as String?,
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      lastModified: json['lastModified'] == null
          ? null
          : DateTime.parse(json['lastModified'] as String),
    );

Map<String, dynamic> _$IpLookupRecordDtoToJson(IpLookupRecordDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'address': instance.address,
      'countryCode': instance.countryCode,
      'region': instance.region,
      'city': instance.city,
      'asn': instance.asn,
      'isp': instance.isp,
      'created': instance.created?.toIso8601String(),
      'lastModified': instance.lastModified?.toIso8601String(),
    };
