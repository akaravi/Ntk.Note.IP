// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'action_register_push_device_command.g.dart';

@JsonSerializable()
class ActionRegisterPushDeviceCommand {
  const ActionRegisterPushDeviceCommand({
    this.deviceToken,
    this.platform,
  });
  
  factory ActionRegisterPushDeviceCommand.fromJson(Map<String, Object?> json) => _$ActionRegisterPushDeviceCommandFromJson(json);
  
  final String? deviceToken;
  final String? platform;

  Map<String, Object?> toJson() => _$ActionRegisterPushDeviceCommandToJson(this);
}
