// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'two_factor_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwoFactorRequest _$TwoFactorRequestFromJson(Map<String, dynamic> json) =>
    TwoFactorRequest(
      enable: json['enable'] as bool?,
      twoFactorCode: json['twoFactorCode'] as String?,
      resetSharedKey: json['resetSharedKey'] as bool?,
      resetRecoveryCodes: json['resetRecoveryCodes'] as bool?,
      forgetMachine: json['forgetMachine'] as bool?,
    );

Map<String, dynamic> _$TwoFactorRequestToJson(TwoFactorRequest instance) =>
    <String, dynamic>{
      'enable': instance.enable,
      'twoFactorCode': instance.twoFactorCode,
      'resetSharedKey': instance.resetSharedKey,
      'resetRecoveryCodes': instance.resetRecoveryCodes,
      'forgetMachine': instance.forgetMachine,
    };
