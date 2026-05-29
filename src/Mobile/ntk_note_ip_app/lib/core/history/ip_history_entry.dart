class IpHistoryEntry {
  const IpHistoryEntry({
    required this.id,
    required this.address,
    required this.isIPv6,
    required this.recordedAt,
    this.scope,
    this.city,
    this.countryCode,
    this.deviceLabel,
  });

  final String id;
  final String address;
  final bool isIPv6;
  final String recordedAt;
  final String? scope;
  final String? city;
  final String? countryCode;
  final String? deviceLabel;

  Map<String, dynamic> toJson() => {
        'id': id,
        'address': address,
        'isIPv6': isIPv6,
        'recordedAt': recordedAt,
        if (scope != null) 'scope': scope,
        if (city != null) 'city': city,
        if (countryCode != null) 'countryCode': countryCode,
        if (deviceLabel != null) 'deviceLabel': deviceLabel,
      };

  factory IpHistoryEntry.fromJson(Map<String, dynamic> json) {
    return IpHistoryEntry(
      id: json['id'] as String? ?? '',
      address: json['address'] as String? ?? '',
      isIPv6: json['isIPv6'] == true,
      recordedAt: json['recordedAt'] as String? ?? '',
      scope: json['scope'] as String?,
      city: json['city'] as String?,
      countryCode: json['countryCode'] as String?,
      deviceLabel: json['deviceLabel'] as String?,
    );
  }
}
