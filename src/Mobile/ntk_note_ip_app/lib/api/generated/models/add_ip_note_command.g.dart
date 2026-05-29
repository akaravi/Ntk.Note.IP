// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_ip_note_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddIpNoteCommand _$AddIpNoteCommandFromJson(Map<String, dynamic> json) =>
    AddIpNoteCommand(
      address: json['address'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      tags: json['tags'] as String?,
      notedAtClient: json['notedAtClient'] == null
          ? null
          : DateTime.parse(json['notedAtClient'] as String),
      clientTimezone: json['clientTimezone'] as String?,
      localIpAddress: json['localIpAddress'] as String?,
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>?,
      ipSnapshot: json['ipSnapshot'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AddIpNoteCommandToJson(AddIpNoteCommand instance) =>
    <String, dynamic>{
      'address': instance.address,
      'title': instance.title,
      'body': instance.body,
      'tags': instance.tags,
      'notedAtClient': instance.notedAtClient?.toIso8601String(),
      'clientTimezone': instance.clientTimezone,
      'localIpAddress': instance.localIpAddress,
      'deviceInfo': instance.deviceInfo,
      'ipSnapshot': instance.ipSnapshot,
    };
