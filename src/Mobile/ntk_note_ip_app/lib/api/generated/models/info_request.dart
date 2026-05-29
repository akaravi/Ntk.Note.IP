// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'info_request.g.dart';

@JsonSerializable()
class InfoRequest {
  const InfoRequest({
    this.newEmail,
    this.newPassword,
    this.oldPassword,
  });
  
  factory InfoRequest.fromJson(Map<String, Object?> json) => _$InfoRequestFromJson(json);
  
  final String? newEmail;
  final String? newPassword;
  final String? oldPassword;

  Map<String, Object?> toJson() => _$InfoRequestToJson(this);
}
