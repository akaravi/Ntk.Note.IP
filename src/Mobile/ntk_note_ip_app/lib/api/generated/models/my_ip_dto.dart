// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'ip_address_scope.dart';

part 'my_ip_dto.g.dart';

@JsonSerializable()
class MyIpDto {
  const MyIpDto({
    this.address,
    this.scope,
    this.isIPv6,
  });
  
  factory MyIpDto.fromJson(Map<String, Object?> json) => _$MyIpDtoFromJson(json);
  
  final String? address;
  final IpAddressScope? scope;
  final bool? isIPv6;

  Map<String, Object?> toJson() => _$MyIpDtoToJson(this);
}
