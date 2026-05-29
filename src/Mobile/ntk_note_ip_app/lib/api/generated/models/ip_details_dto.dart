// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'asn_info_dto.dart';
import 'geo_location_dto.dart';
import 'ip_address_scope.dart';

part 'ip_details_dto.g.dart';

@JsonSerializable()
class IpDetailsDto {
  const IpDetailsDto({
    this.address,
    this.scope,
    this.isIPv6,
    this.geo,
    this.asn,
    this.isp,
    this.reverseDns,
  });
  
  factory IpDetailsDto.fromJson(Map<String, Object?> json) => _$IpDetailsDtoFromJson(json);
  
  final String? address;
  final IpAddressScope? scope;
  final bool? isIPv6;
  final GeoLocationDto? geo;
  final AsnInfoDto? asn;
  final String? isp;
  final String? reverseDns;

  Map<String, Object?> toJson() => _$IpDetailsDtoToJson(this);
}
