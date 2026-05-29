// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'two_factor_request.g.dart';

@JsonSerializable()
class TwoFactorRequest {
  const TwoFactorRequest({
    this.enable,
    this.twoFactorCode,
    this.resetSharedKey,
    this.resetRecoveryCodes,
    this.forgetMachine,
  });
  
  factory TwoFactorRequest.fromJson(Map<String, Object?> json) => _$TwoFactorRequestFromJson(json);
  
  final bool? enable;
  final String? twoFactorCode;
  final bool? resetSharedKey;
  final bool? resetRecoveryCodes;
  final bool? forgetMachine;

  Map<String, Object?> toJson() => _$TwoFactorRequestToJson(this);
}
