import '../domain/entities/ip_details.dart';
import '../domain/entities/ip_note_add_snapshot.dart';
import '../domain/usecases/get_ip_details.dart';
import 'device/device_info_summary.dart';
import 'network/local_ip_service.dart';

class IpNoteSnapshotBuilder {
  IpNoteSnapshotBuilder({
    required GetIpDetailsUseCase getIpDetails,
    LocalIpService? localIpService,
  })  : _getIpDetails = getIpDetails,
        _localIpService = localIpService ?? LocalIpService();

  final GetIpDetailsUseCase _getIpDetails;
  final LocalIpService _localIpService;

  Future<IpNoteAddSnapshot> buildForAddress(String address) async {
    final deviceFuture = DeviceInfoSummary.load();
    final detailsFuture = _getIpDetails.call(address);
    final localIpFuture = _localIpService.discoverLocalIpv4();

    final device = await deviceFuture;
    final localIp = await localIpFuture;
    final detailsResult = await detailsFuture;

    return IpNoteAddSnapshot(
      notedAtClient: DateTime.now(),
      clientTimezone: DateTime.now().timeZoneName,
      localIpAddress: localIp,
      deviceInfo: {
        'browser': device.device,
        'os': device.os,
        'deviceType': device.device,
        'language': device.language,
        'label': device.label,
      },
      ipSnapshot: _detailsToJson(detailsResult.data),
    );
  }

  Map<String, dynamic>? _detailsToJson(IpDetails? details) {
    if (details == null) {
      return null;
    }

    return {
      'address': details.address,
      'scope': details.scope,
      'isIPv6': details.isIPv6,
      'geo': {
        'latitude': details.geo.latitude,
        'longitude': details.geo.longitude,
        'countryCode': details.geo.countryCode,
        'country': details.geo.country,
        'region': details.geo.region,
        'city': details.geo.city,
        'timezone': details.geo.timezone,
      },
      'asn': {
        'number': details.asn.number,
        'organization': details.asn.organization,
      },
      'isp': details.isp,
      'reverseDns': details.reverseDns,
    };
  }
}
