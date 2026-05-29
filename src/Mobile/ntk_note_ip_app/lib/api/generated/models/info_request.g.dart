// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoRequest _$InfoRequestFromJson(Map<String, dynamic> json) => InfoRequest(
  newEmail: json['newEmail'] as String?,
  newPassword: json['newPassword'] as String?,
  oldPassword: json['oldPassword'] as String?,
);

Map<String, dynamic> _$InfoRequestToJson(InfoRequest instance) =>
    <String, dynamic>{
      'newEmail': instance.newEmail,
      'newPassword': instance.newPassword,
      'oldPassword': instance.oldPassword,
    };
