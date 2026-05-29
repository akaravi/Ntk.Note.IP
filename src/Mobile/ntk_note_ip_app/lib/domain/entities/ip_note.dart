class IpNote {
  const IpNote({
    required this.id,
    required this.address,
    required this.created,
    this.title,
    this.body,
    this.tags,
    this.notedAtClient,
    this.clientTimezone,
    this.localIpAddress,
    this.countryCode,
    this.region,
    this.city,
    this.isp,
    this.asn,
    this.deviceLabel,
  });

  final int id;
  final String address;
  final String created;
  final String? title;
  final String? body;
  final String? tags;
  final String? notedAtClient;
  final String? clientTimezone;
  final String? localIpAddress;
  final String? countryCode;
  final String? region;
  final String? city;
  final String? isp;
  final String? asn;
  final String? deviceLabel;

  factory IpNote.fromJson(Map<String, dynamic> json) {
    return IpNote(
      id: _toInt(json['id']),
      address: json['address']?.toString() ?? '',
      created: json['created']?.toString() ?? '',
      title: json['title']?.toString(),
      body: json['body']?.toString(),
      tags: json['tags']?.toString(),
      notedAtClient: json['notedAtClient']?.toString(),
      clientTimezone: json['clientTimezone']?.toString(),
      localIpAddress: json['localIpAddress']?.toString(),
      countryCode: json['countryCode']?.toString(),
      region: json['region']?.toString(),
      city: json['city']?.toString(),
      isp: json['isp']?.toString(),
      asn: json['asn']?.toString(),
      deviceLabel: json['deviceLabel']?.toString(),
    );
  }

  List<String> get tagList {
    if (tags == null || tags!.trim().isEmpty) {
      return const [];
    }

    return tags!
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();
  }

  String get locationLine {
    return [
      city,
      region,
      countryCode?.toUpperCase(),
    ].whereType<String>().where((v) => v.isNotEmpty).join(' · ');
  }

  String get notedWhen => notedAtClient ?? created;
}

int _toInt(Object? value) {
  if (value is int) {
    return value;
  }

  return int.tryParse(value?.toString() ?? '') ?? 0;
}
