class MonitorMyIpResult {
  const MonitorMyIpResult({
    required this.address,
    required this.ipChanged,
    this.previousAddress,
  });

  final String address;
  final bool ipChanged;
  final String? previousAddress;
}
