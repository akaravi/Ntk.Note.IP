// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_register_push_device_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionRegisterPushDeviceCommand _$ActionRegisterPushDeviceCommandFromJson(
  Map<String, dynamic> json,
) => ActionRegisterPushDeviceCommand(
  deviceToken: json['deviceToken'] as String?,
  platform: json['platform'] as String?,
);

Map<String, dynamic> _$ActionRegisterPushDeviceCommandToJson(
  ActionRegisterPushDeviceCommand instance,
) => <String, dynamic>{
  'deviceToken': instance.deviceToken,
  'platform': instance.platform,
};
