// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reverse_dns_dto.g.dart';

@JsonSerializable()
class ReverseDnsDto {
  const ReverseDnsDto({
    this.address,
    this.hostName,
  });
  
  factory ReverseDnsDto.fromJson(Map<String, Object?> json) => _$ReverseDnsDtoFromJson(json);
  
  final String? address;
  final String? hostName;

  Map<String, Object?> toJson() => _$ReverseDnsDtoToJson(this);
}
