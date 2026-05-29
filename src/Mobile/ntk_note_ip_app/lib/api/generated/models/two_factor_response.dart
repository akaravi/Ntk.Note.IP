// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'two_factor_response.g.dart';

@JsonSerializable()
class TwoFactorResponse {
  const TwoFactorResponse({
    required this.sharedKey,
    required this.recoveryCodesLeft,
    required this.isTwoFactorEnabled,
    required this.isMachineRemembered,
    this.recoveryCodes,
  });
  
  factory TwoFactorResponse.fromJson(Map<String, Object?> json) => _$TwoFactorResponseFromJson(json);
  
  final String sharedKey;
  final dynamic recoveryCodesLeft;
  final List<String>? recoveryCodes;
  final bool isTwoFactorEnabled;
  final bool isMachineRemembered;

  Map<String, Object?> toJson() => _$TwoFactorResponseToJson(this);
}
