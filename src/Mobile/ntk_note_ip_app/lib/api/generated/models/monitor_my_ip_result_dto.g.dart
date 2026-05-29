// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monitor_my_ip_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MonitorMyIpResultDto _$MonitorMyIpResultDtoFromJson(
  Map<String, dynamic> json,
) => MonitorMyIpResultDto(
  address: json['address'] as String?,
  ipChanged: json['ipChanged'] as bool?,
  previousAddress: json['previousAddress'] as String?,
);

Map<String, dynamic> _$MonitorMyIpResultDtoToJson(
  MonitorMyIpResultDto instance,
) => <String, dynamic>{
  'address': instance.address,
  'ipChanged': instance.ipChanged,
  'previousAddress': instance.previousAddress,
};
