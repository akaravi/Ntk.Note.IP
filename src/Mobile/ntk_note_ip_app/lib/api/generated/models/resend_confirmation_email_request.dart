// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'resend_confirmation_email_request.g.dart';

@JsonSerializable()
class ResendConfirmationEmailRequest {
  const ResendConfirmationEmailRequest({
    required this.email,
  });
  
  factory ResendConfirmationEmailRequest.fromJson(Map<String, Object?> json) => _$ResendConfirmationEmailRequestFromJson(json);
  
  final String email;

  Map<String, Object?> toJson() => _$ResendConfirmationEmailRequestToJson(this);
}
