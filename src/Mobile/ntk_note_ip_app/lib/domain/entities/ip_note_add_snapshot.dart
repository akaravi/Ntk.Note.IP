class IpNoteAddSnapshot {
  const IpNoteAddSnapshot({
    required this.notedAtClient,
    required this.clientTimezone,
    this.localIpAddress,
    this.deviceInfo,
    this.ipSnapshot,
  });

  final DateTime notedAtClient;
  final String clientTimezone;
  final String? localIpAddress;
  final Map<String, dynamic>? deviceInfo;
  final Map<String, dynamic>? ipSnapshot;

  Map<String, dynamic> toJson() => {
        'notedAtClient': notedAtClient.toUtc().toIso8601String(),
        'clientTimezone': clientTimezone,
        if (localIpAddress != null && localIpAddress!.isNotEmpty)
          'localIpAddress': localIpAddress,
        if (deviceInfo != null) 'deviceInfo': deviceInfo,
        if (ipSnapshot != null) 'ipSnapshot': ipSnapshot,
      };
}
