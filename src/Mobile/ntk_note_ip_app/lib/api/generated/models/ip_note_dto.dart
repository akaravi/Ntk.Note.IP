// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'ip_note_dto.g.dart';

@JsonSerializable()
class IpNoteDto {
  const IpNoteDto({
    this.id,
    this.address,
    this.title,
    this.body,
    this.tags,
    this.created,
    this.lastModified,
    this.notedAtClient,
    this.clientTimezone,
    this.localIpAddress,
    this.countryCode,
    this.region,
    this.city,
    this.isp,
    this.asn,
    this.deviceLabel,
    this.deviceInfo,
    this.ipSnapshot,
  });
  
  factory IpNoteDto.fromJson(Map<String, Object?> json) => _$IpNoteDtoFromJson(json);
  
  final dynamic id;
  final String? address;
  final String? title;
  final String? body;
  final String? tags;
  final DateTime? created;
  final DateTime? lastModified;
  final DateTime? notedAtClient;
  final String? clientTimezone;
  final String? localIpAddress;
  final String? countryCode;
  final String? region;
  final String? city;
  final String? isp;
  final String? asn;
  final String? deviceLabel;
  final Map<String, dynamic>? deviceInfo;
  final Map<String, dynamic>? ipSnapshot;

  Map<String, Object?> toJson() => _$IpNoteDtoToJson(this);
}
