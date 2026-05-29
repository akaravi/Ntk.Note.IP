// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_ip_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyIpDto _$MyIpDtoFromJson(Map<String, dynamic> json) => MyIpDto(
  address: json['address'] as String?,
  scope: (json['scope'] as num?)?.toInt(),
  isIPv6: json['isIPv6'] as bool?,
);

Map<String, dynamic> _$MyIpDtoToJson(MyIpDto instance) => <String, dynamic>{
  'address': instance.address,
  'scope': instance.scope,
  'isIPv6': instance.isIPv6,
};
