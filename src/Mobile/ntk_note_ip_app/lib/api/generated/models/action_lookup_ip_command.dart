// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'action_lookup_ip_command.g.dart';

@JsonSerializable()
class ActionLookupIpCommand {
  const ActionLookupIpCommand({
    this.address,
  });
  
  factory ActionLookupIpCommand.fromJson(Map<String, Object?> json) => _$ActionLookupIpCommandFromJson(json);
  
  final String? address;

  Map<String, Object?> toJson() => _$ActionLookupIpCommandToJson(this);
}
