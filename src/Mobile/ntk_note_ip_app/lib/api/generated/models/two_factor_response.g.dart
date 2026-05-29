// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'two_factor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwoFactorResponse _$TwoFactorResponseFromJson(Map<String, dynamic> json) =>
    TwoFactorResponse(
      sharedKey: json['sharedKey'] as String,
      recoveryCodesLeft: json['recoveryCodesLeft'],
      isTwoFactorEnabled: json['isTwoFactorEnabled'] as bool,
      isMachineRemembered: json['isMachineRemembered'] as bool,
      recoveryCodes: (json['recoveryCodes'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TwoFactorResponseToJson(TwoFactorResponse instance) =>
    <String, dynamic>{
      'sharedKey': instance.sharedKey,
      'recoveryCodesLeft': instance.recoveryCodesLeft,
      'recoveryCodes': instance.recoveryCodes,
      'isTwoFactorEnabled': instance.isTwoFactorEnabled,
      'isMachineRemembered': instance.isMachineRemembered,
    };
