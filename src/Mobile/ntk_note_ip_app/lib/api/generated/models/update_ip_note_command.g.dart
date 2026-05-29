// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_ip_note_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateIpNoteCommand _$UpdateIpNoteCommandFromJson(Map<String, dynamic> json) =>
    UpdateIpNoteCommand(
      id: json['id'],
      address: json['address'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      tags: json['tags'] as String?,
    );

Map<String, dynamic> _$UpdateIpNoteCommandToJson(
  UpdateIpNoteCommand instance,
) => <String, dynamic>{
  'id': instance.id,
  'address': instance.address,
  'title': instance.title,
  'body': instance.body,
  'tags': instance.tags,
};
