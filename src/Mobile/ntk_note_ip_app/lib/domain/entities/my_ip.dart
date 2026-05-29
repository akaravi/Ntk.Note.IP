class MyIp {
  const MyIp({
    required this.address,
    required this.scope,
    required this.isIPv6,
  });

  final String address;
  final String scope;
  final bool isIPv6;
}
