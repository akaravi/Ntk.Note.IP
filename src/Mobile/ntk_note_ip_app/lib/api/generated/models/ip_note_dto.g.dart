// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip_note_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IpNoteDto _$IpNoteDtoFromJson(Map<String, dynamic> json) => IpNoteDto(
  id: json['id'],
  address: json['address'] as String?,
  title: json['title'] as String?,
  body: json['body'] as String?,
  tags: json['tags'] as String?,
  created: json['created'] == null
      ? null
      : DateTime.parse(json['created'] as String),
  lastModified: json['lastModified'] == null
      ? null
      : DateTime.parse(json['lastModified'] as String),
  notedAtClient: json['notedAtClient'] == null
      ? null
      : DateTime.parse(json['notedAtClient'] as String),
  clientTimezone: json['clientTimezone'] as String?,
  localIpAddress: json['localIpAddress'] as String?,
  countryCode: json['countryCode'] as String?,
  region: json['region'] as String?,
  city: json['city'] as String?,
  isp: json['isp'] as String?,
  asn: json['asn'] as String?,
  deviceLabel: json['deviceLabel'] as String?,
  deviceInfo: json['deviceInfo'] as Map<String, dynamic>?,
  ipSnapshot: json['ipSnapshot'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$IpNoteDtoToJson(IpNoteDto instance) => <String, dynamic>{
  'id': instance.id,
  'address': instance.address,
  'title': instance.title,
  'body': instance.body,
  'tags': instance.tags,
  'created': instance.created?.toIso8601String(),
  'lastModified': instance.lastModified?.toIso8601String(),
  'notedAtClient': instance.notedAtClient?.toIso8601String(),
  'clientTimezone': instance.clientTimezone,
  'localIpAddress': instance.localIpAddress,
  'countryCode': instance.countryCode,
  'region': instance.region,
  'city': instance.city,
  'isp': instance.isp,
  'asn': instance.asn,
  'deviceLabel': instance.deviceLabel,
  'deviceInfo': instance.deviceInfo,
  'ipSnapshot': instance.ipSnapshot,
};
