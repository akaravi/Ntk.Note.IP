class GeoLocation {
  const GeoLocation({
    this.latitude,
    this.longitude,
    this.countryCode,
    this.country,
    this.region,
    this.city,
    this.timezone,
  });

  final double? latitude;
  final double? longitude;
  final String? countryCode;
  final String? country;
  final String? region;
  final String? city;
  final String? timezone;

  factory GeoLocation.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GeoLocation();
    }

    return GeoLocation(
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      countryCode: json['countryCode']?.toString(),
      country: json['country']?.toString(),
      region: json['region']?.toString(),
      city: json['city']?.toString(),
      timezone: json['timezone']?.toString(),
    );
  }

  bool get hasCoordinates => latitude != null && longitude != null;
}

class AsnInfo {
  const AsnInfo({
    this.number,
    this.organization,
  });

  final String? number;
  final String? organization;

  factory AsnInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AsnInfo();
    }

    return AsnInfo(
      number: json['number']?.toString(),
      organization: json['organization']?.toString(),
    );
  }
}

class IpDetails {
  const IpDetails({
    required this.address,
    required this.scope,
    required this.isIPv6,
    required this.geo,
    required this.asn,
    this.isp,
    this.reverseDns,
  });

  final String address;
  final String scope;
  final bool isIPv6;
  final GeoLocation geo;
  final AsnInfo asn;
  final String? isp;
  final String? reverseDns;

  factory IpDetails.fromJson(Map<String, dynamic> json) {
    return IpDetails(
      address: json['address']?.toString() ?? '',
      scope: json['scope']?.toString() ?? '',
      isIPv6: json['isIPv6'] == true,
      geo: GeoLocation.fromJson(json['geo'] as Map<String, dynamic>?),
      asn: AsnInfo.fromJson(json['asn'] as Map<String, dynamic>?),
      isp: json['isp']?.toString(),
      reverseDns: json['reverseDns']?.toString(),
    );
  }
}

double? _toDouble(Object? value) {
  if (value == null) {
    return null;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(value.toString());
}
