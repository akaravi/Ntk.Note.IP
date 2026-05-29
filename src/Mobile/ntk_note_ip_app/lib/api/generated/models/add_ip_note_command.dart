// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'add_ip_note_command.g.dart';

@JsonSerializable(includeIfNull: false)
class AddIpNoteCommand {
  const AddIpNoteCommand({
    this.address,
    this.title,
    this.body,
    this.tags,
    this.notedAtClient,
    this.clientTimezone,
    this.localIpAddress,
    this.deviceInfo,
    this.ipSnapshot,
  });
  
  factory AddIpNoteCommand.fromJson(Map<String, Object?> json) => _$AddIpNoteCommandFromJson(json);
  
  final String? address;
  final String? title;
  final String? body;
  final String? tags;
  final DateTime? notedAtClient;
  final String? clientTimezone;
  final String? localIpAddress;
  final Map<String, dynamic>? deviceInfo;
  final Map<String, dynamic>? ipSnapshot;

  Map<String, Object?> toJson() => _$AddIpNoteCommandToJson(this);
}
