// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'asn_info_dto.g.dart';

@JsonSerializable()
class AsnInfoDto {
  const AsnInfoDto({
    this.number,
    this.organization,
  });
  
  factory AsnInfoDto.fromJson(Map<String, Object?> json) => _$AsnInfoDtoFromJson(json);
  
  final String? number;
  final String? organization;

  Map<String, Object?> toJson() => _$AsnInfoDtoToJson(this);
}
