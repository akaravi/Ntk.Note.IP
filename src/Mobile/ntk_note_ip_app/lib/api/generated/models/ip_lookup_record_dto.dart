// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'ip_lookup_record_dto.g.dart';

@JsonSerializable()
class IpLookupRecordDto {
  const IpLookupRecordDto({
    this.id,
    this.address,
    this.countryCode,
    this.region,
    this.city,
    this.asn,
    this.isp,
    this.created,
    this.lastModified,
  });
  
  factory IpLookupRecordDto.fromJson(Map<String, Object?> json) => _$IpLookupRecordDtoFromJson(json);
  
  final dynamic id;
  final String? address;
  final String? countryCode;
  final String? region;
  final String? city;
  final String? asn;
  final String? isp;
  final DateTime? created;
  final DateTime? lastModified;

  Map<String, Object?> toJson() => _$IpLookupRecordDtoToJson(this);
}
