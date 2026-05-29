// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'action_unregister_push_device_command.g.dart';

@JsonSerializable()
class ActionUnregisterPushDeviceCommand {
  const ActionUnregisterPushDeviceCommand({
    this.deviceToken,
  });
  
  factory ActionUnregisterPushDeviceCommand.fromJson(Map<String, Object?> json) => _$ActionUnregisterPushDeviceCommandFromJson(json);
  
  final String? deviceToken;

  Map<String, Object?> toJson() => _$ActionUnregisterPushDeviceCommandToJson(this);
}
