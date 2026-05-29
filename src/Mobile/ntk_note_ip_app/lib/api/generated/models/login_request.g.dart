// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
  email: json['email'] as String,
  password: json['password'] as String,
  twoFactorCode: json['twoFactorCode'] as String?,
  twoFactorRecoveryCode: json['twoFactorRecoveryCode'] as String?,
);

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'twoFactorCode': instance.twoFactorCode,
      'twoFactorRecoveryCode': instance.twoFactorRecoveryCode,
    };
