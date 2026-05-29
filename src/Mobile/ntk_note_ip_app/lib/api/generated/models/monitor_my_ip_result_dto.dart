// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'monitor_my_ip_result_dto.g.dart';

@JsonSerializable()
class MonitorMyIpResultDto {
  const MonitorMyIpResultDto({
    this.address,
    this.ipChanged,
    this.previousAddress,
  });
  
  factory MonitorMyIpResultDto.fromJson(Map<String, Object?> json) => _$MonitorMyIpResultDtoFromJson(json);
  
  final String? address;
  final bool? ipChanged;
  final String? previousAddress;

  Map<String, Object?> toJson() => _$MonitorMyIpResultDtoToJson(this);
}
