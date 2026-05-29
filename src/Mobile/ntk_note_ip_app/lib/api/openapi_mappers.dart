import '../domain/entities/ip_details.dart';
import '../domain/entities/ip_lookup_record.dart';
import '../domain/entities/ip_note.dart';
import '../domain/entities/monitor_my_ip_result.dart';
import '../domain/entities/my_ip.dart';
import 'generated/models/asn_info_dto.dart';
import 'generated/models/geo_location_dto.dart';
import 'generated/models/ip_address_scope.dart';
import 'generated/models/ip_details_dto.dart';
import 'generated/models/ip_lookup_record_dto.dart';
import 'generated/models/ip_note_dto.dart';
import 'generated/models/monitor_my_ip_result_dto.dart';
import 'generated/models/my_ip_dto.dart';

/// Maps OpenAPI-generated DTOs to domain entities (hand-written layer).
class OpenApiMappers {
  const OpenApiMappers._();

  static IpLookupRecord toIpLookupRecord(IpLookupRecordDto dto) {
    return IpLookupRecord(
      id: _toInt(dto.id),
      address: dto.address ?? '',
      created: _formatDateTime(dto.created),
      countryCode: dto.countryCode,
      region: dto.region,
      city: dto.city,
      asn: dto.asn,
      isp: dto.isp,
    );
  }

  static IpLookupRecord ipLookupRecordFromJson(Map<String, dynamic> json) {
    return toIpLookupRecord(
      IpLookupRecordDto.fromJson(json.cast<String, Object?>()),
    );
  }

  static MyIp toMyIp(MyIpDto dto) {
    return MyIp(
      address: dto.address ?? '',
      scope: _scopeLabel(dto.scope),
      isIPv6: dto.isIPv6 == true,
    );
  }

  static MyIp myIpFromJson(Map<String, dynamic> json) {
    return toMyIp(MyIpDto.fromJson(json.cast<String, Object?>()));
  }

  static IpDetails toIpDetails(IpDetailsDto dto) {
    return IpDetails(
      address: dto.address ?? '',
      scope: _scopeLabel(dto.scope),
      isIPv6: dto.isIPv6 == true,
      geo: _toGeo(dto.geo),
      asn: _toAsn(dto.asn),
      isp: dto.isp,
      reverseDns: dto.reverseDns,
    );
  }

  static IpDetails ipDetailsFromJson(Map<String, dynamic> json) {
    return toIpDetails(IpDetailsDto.fromJson(json.cast<String, Object?>()));
  }

  static IpNote toIpNote(IpNoteDto dto) {
    return IpNote(
      id: _toInt(dto.id),
      address: dto.address ?? '',
      created: _formatDateTime(dto.created),
      title: dto.title,
      body: dto.body,
      tags: dto.tags,
      notedAtClient: _formatDateTime(dto.notedAtClient),
      clientTimezone: dto.clientTimezone,
      localIpAddress: dto.localIpAddress,
      countryCode: dto.countryCode,
      region: dto.region,
      city: dto.city,
      isp: dto.isp,
      asn: dto.asn,
      deviceLabel: dto.deviceLabel,
    );
  }

  static IpNote ipNoteFromJson(Map<String, dynamic> json) {
    return toIpNote(IpNoteDto.fromJson(json.cast<String, Object?>()));
  }

  static GeoLocation _toGeo(GeoLocationDto? dto) {
    if (dto == null) {
      return const GeoLocation();
    }

    return GeoLocation(
      latitude: _toDouble(dto.latitude),
      longitude: _toDouble(dto.longitude),
      countryCode: dto.countryCode,
      country: dto.country,
      region: dto.region,
      city: dto.city,
      timezone: dto.timezone,
    );
  }

  static AsnInfo _toAsn(AsnInfoDto? dto) {
    if (dto == null) {
      return const AsnInfo();
    }

    return AsnInfo(
      number: dto.number?.toString(),
      organization: dto.organization?.toString(),
    );
  }

  static String _scopeLabel(IpAddressScope? scope) {
    if (scope == null) {
      return '';
    }

    return scope.toString();
  }

  static int _toInt(Object? value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double? _toDouble(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  static String _formatDateTime(DateTime? value) {
    if (value == null) {
      return '';
    }

    return value.toUtc().toIso8601String();
  }

  static MonitorMyIpResult toMonitorMyIpResult(MonitorMyIpResultDto dto) {
    return MonitorMyIpResult(
      address: dto.address ?? '',
      ipChanged: dto.ipChanged == true,
      previousAddress: dto.previousAddress,
    );
  }

  static MonitorMyIpResult monitorMyIpResultFromJson(Map<String, dynamic> json) {
    return toMonitorMyIpResult(
      MonitorMyIpResultDto.fromJson(json.cast<String, Object?>()),
    );
  }
}
