// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoResponse _$InfoResponseFromJson(Map<String, dynamic> json) => InfoResponse(
  email: json['email'] as String,
  isEmailConfirmed: json['isEmailConfirmed'] as bool,
);

Map<String, dynamic> _$InfoResponseToJson(InfoResponse instance) =>
    <String, dynamic>{
      'email': instance.email,
      'isEmailConfirmed': instance.isEmailConfirmed,
    };
