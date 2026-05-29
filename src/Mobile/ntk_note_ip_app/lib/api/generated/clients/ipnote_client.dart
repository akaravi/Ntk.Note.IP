// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/access_token_response.dart';
import '../models/action_lookup_ip_command.dart';
import '../models/action_register_push_device_command.dart';
import '../models/action_unregister_push_device_command.dart';
import '../models/add_ip_note_command.dart';
import '../models/error_exception_result_of_asn_info_dto.dart';
import '../models/error_exception_result_of_geo_location_dto.dart';
import '../models/error_exception_result_of_ip_details_dto.dart';
import '../models/error_exception_result_of_ip_lookup_record_dto.dart';
import '../models/error_exception_result_of_ip_note_dto.dart';
import '../models/error_exception_result_of_list_of_ip_lookup_record_dto.dart';
import '../models/error_exception_result_of_list_of_ip_note_dto.dart';
import '../models/error_exception_result_of_monitor_my_ip_result_dto.dart';
import '../models/error_exception_result_of_my_ip_dto.dart';
import '../models/error_exception_result_of_reverse_dns_dto.dart';
import '../models/error_exception_result_ofint.dart';
import '../models/forgot_password_request.dart';
import '../models/info_request.dart';
import '../models/info_response.dart';
import '../models/login_request.dart';
import '../models/refresh_request.dart';
import '../models/register_request.dart';
import '../models/resend_confirmation_email_request.dart';
import '../models/reset_password_request.dart';
import '../models/two_factor_request.dart';
import '../models/two_factor_response.dart';
import '../models/update_ip_note_command.dart';

part 'ipnote_client.g.dart';

@RestApi()
abstract class IpnoteClient {
  factory IpnoteClient(Dio dio, {String? baseUrl}) = _IpnoteClient;

  /// GetMyIp.
  ///
  /// Returns the caller's IP address and scope (public/private/loopback).
  @GET('/api/v1/IpLookup/GetMyIp')
  Future<ErrorExceptionResultOfMyIpDto> getMyIp();

  /// GetMyIpPlain.
  ///
  /// Returns the caller IP address as plain text (curl-friendly).
  @GET('/api/v1/IpLookup/GetMyIpPlain')
  Future<String> getMyIpPlain();

  /// GetIpDetails.
  ///
  /// Geo, ASN, ISP and reverse DNS for an IP address.
  @GET('/api/v1/IpLookup/GetIpDetails')
  Future<ErrorExceptionResultOfIpDetailsDto> getIpDetails({
    @Query('address') required String address,
  });

  /// GetGeoLocation.
  ///
  /// Geolocation for an IP address.
  @GET('/api/v1/IpLookup/GetGeoLocation')
  Future<ErrorExceptionResultOfGeoLocationDto> getGeoLocation({
    @Query('address') required String address,
  });

  /// GetAsnInfo.
  ///
  /// ASN and organization for an IP address.
  @GET('/api/v1/IpLookup/GetAsnInfo')
  Future<ErrorExceptionResultOfAsnInfoDto> getAsnInfo({
    @Query('address') required String address,
  });

  /// GetReverseDns.
  ///
  /// PTR reverse DNS hostname for an IP address.
  @GET('/api/v1/IpLookup/GetReverseDns')
  Future<ErrorExceptionResultOfReverseDnsDto> getReverseDns({
    @Query('address') required String address,
  });

  /// ActionLookup IP.
  ///
  /// Runs an external geo/ASN lookup for the given IP and stores the result.
  @POST('/api/v1/IpLookup/ActionLookup')
  Future<ErrorExceptionResultOfIpLookupRecordDto> actionLookup({
    @Body() required ActionLookupIpCommand body,
  });

  /// ActionMonitorMyIp.
  ///
  /// Records the caller public IP for the authenticated user and sends push when it changes.
  @POST('/api/v1/IpLookup/ActionMonitorMyIp')
  Future<ErrorExceptionResultOfMonitorMyIpResultDto> actionMonitorMyIp();

  /// GetList IP lookup history.
  ///
  /// Returns cached lookup records as a homogeneous list in data.
  @GET('/api/v1/IpLookup')
  Future<ErrorExceptionResultOfListOfIpLookupRecordDto> getListIpLookupRecords();

  /// GetOne IP lookup record.
  ///
  /// Returns a single lookup record by id.
  @GET('/api/v1/IpLookup/{id}')
  Future<ErrorExceptionResultOfIpLookupRecordDto> getOneIpLookupRecord({
    @Path('id') required dynamic id,
  });

  /// GetList IP notes.
  ///
  /// Returns all IP notes for the authenticated user as a homogeneous list in data.
  @GET('/api/v1/IpNotes')
  Future<ErrorExceptionResultOfListOfIpNoteDto> getListIpNotes();

  /// Add IP note.
  ///
  /// Creates a new IP note.
  @POST('/api/v1/IpNotes')
  Future<ErrorExceptionResultOfint> addIpNote({
    @Body() required AddIpNoteCommand body,
  });

  /// GetOne IP note.
  ///
  /// Returns a single IP note by id.
  @GET('/api/v1/IpNotes/{id}')
  Future<ErrorExceptionResultOfIpNoteDto> getOneIpNote({
    @Path('id') required dynamic id,
  });

  /// Update IP note.
  ///
  /// Updates an existing IP note.
  @PUT('/api/v1/IpNotes/{id}')
  Future<void> updateIpNote({
    @Path('id') required dynamic id,
    @Body() required UpdateIpNoteCommand body,
  });

  /// Delete IP note.
  ///
  /// Deletes an IP note by id.
  @DELETE('/api/v1/IpNotes/{id}')
  Future<void> deleteIpNote({
    @Path('id') required dynamic id,
  });

  /// ActionRegister push device.
  ///
  /// Registers or updates an FCM/APNs device token for the authenticated user.
  @POST('/api/v1/PushDevice/ActionRegister')
  Future<void> actionRegister({
    @Body() required ActionRegisterPushDeviceCommand body,
  });

  /// ActionUnregister push device.
  ///
  /// Removes a device token for the authenticated user (e.g. on logout).
  @POST('/api/v1/PushDevice/ActionUnregister')
  Future<void> actionUnregister({
    @Body() required ActionUnregisterPushDeviceCommand body,
  });

  /// Register.
  ///
  /// Creates a new user account.
  @POST('/api/v1/Users/register')
  Future<void> postApiV1UsersRegister({
    @Body() required RegisterRequest body,
  });

  /// Log in.
  ///
  /// Authenticates a user. Use ?useCookies=true for cookie-based authentication.
  @POST('/api/v1/Users/login')
  Future<AccessTokenResponse> postApiV1UsersLogin({
    @Body() required LoginRequest body,
    @Query('useCookies') bool? useCookies,
    @Query('useSessionCookies') bool? useSessionCookies,
  });

  /// Refresh token.
  ///
  /// Returns a new access token using a valid refresh token.
  @POST('/api/v1/Users/refresh')
  Future<AccessTokenResponse> postApiV1UsersRefresh({
    @Body() required RefreshRequest body,
  });

  /// Confirm email.
  ///
  /// Confirms a user's email address using the token sent by email.
  @GET('/api/v1/Users/confirmEmail')
  Future<void> mapIdentityApiApiV1UsersConfirmEmail({
    @Query('userId') required String userId,
    @Query('code') required String code,
    @Query('changedEmail') String? changedEmail,
  });

  /// Resend confirmation email.
  ///
  /// Sends a new email confirmation link to the specified address.
  @POST('/api/v1/Users/resendConfirmationEmail')
  Future<void> postApiV1UsersResendConfirmationEmail({
    @Body() required ResendConfirmationEmailRequest body,
  });

  /// Forgot password.
  ///
  /// Sends a password reset link to the specified email address.
  @POST('/api/v1/Users/forgotPassword')
  Future<void> postApiV1UsersForgotPassword({
    @Body() required ForgotPasswordRequest body,
  });

  /// Reset password.
  ///
  /// Resets a user's password using the token sent by email.
  @POST('/api/v1/Users/resetPassword')
  Future<void> postApiV1UsersResetPassword({
    @Body() required ResetPasswordRequest body,
  });

  /// Manage two-factor authentication.
  ///
  /// Enables, disables, or retrieves two-factor authentication settings.
  @POST('/api/v1/Users/manage/2fa')
  Future<TwoFactorResponse> postApiV1UsersManage2fa({
    @Body() required TwoFactorRequest body,
  });

  /// Get account info.
  ///
  /// Returns the current user's email and two-factor authentication status.
  @GET('/api/v1/Users/manage/info')
  Future<InfoResponse> getApiV1UsersManageInfo();

  /// Update account info.
  ///
  /// Updates the current user's email or password.
  @POST('/api/v1/Users/manage/info')
  Future<InfoResponse> postApiV1UsersManageInfo({
    @Body() required InfoRequest body,
  });

  /// Log out.
  ///
  /// Logs out the current user by clearing the authentication cookie.
  @POST('/api/v1/Users/logout')
  Future<void> logout({
    @Body() required dynamic body,
  });
}
