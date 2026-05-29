// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_ip_note_command.g.dart';

@JsonSerializable()
class UpdateIpNoteCommand {
  const UpdateIpNoteCommand({
    this.id,
    this.address,
    this.title,
    this.body,
    this.tags,
  });
  
  factory UpdateIpNoteCommand.fromJson(Map<String, Object?> json) => _$UpdateIpNoteCommandFromJson(json);
  
  final dynamic id;
  final String? address;
  final String? title;
  final String? body;
  final String? tags;

  Map<String, Object?> toJson() => _$UpdateIpNoteCommandToJson(this);
}
