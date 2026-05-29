class IpLookupRecord {
  const IpLookupRecord({
    required this.id,
    required this.address,
    required this.created,
    this.countryCode,
    this.region,
    this.city,
    this.asn,
    this.isp,
  });

  final int id;
  final String address;
  final String created;
  final String? countryCode;
  final String? region;
  final String? city;
  final String? asn;
  final String? isp;

  factory IpLookupRecord.fromJson(Map<String, dynamic> json) {
    return IpLookupRecord(
      id: _toInt(json['id']),
      address: json['address']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      countryCode: json['countryCode']?.toString(),
      region: json['region']?.toString(),
      city: json['city']?.toString(),
      asn: json['asn']?.toString(),
      isp: json['isp']?.toString(),
    );
  }
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
