class WhoisIpResult {
  const WhoisIpResult({
    required this.address,
    this.handle,
    this.name,
    this.country,
    this.startAddress,
    this.endAddress,
    this.type,
    this.registrationDate,
  });

  final String address;
  final String? handle;
  final String? name;
  final String? country;
  final String? startAddress;
  final String? endAddress;
  final String? type;
  final String? registrationDate;

  factory WhoisIpResult.fromJson(Map<String, dynamic> json) {
    return WhoisIpResult(
      address: json['address'] as String? ?? '',
      handle: json['handle'] as String?,
      name: json['name'] as String?,
      country: json['country'] as String?,
      startAddress: json['startAddress'] as String?,
      endAddress: json['endAddress'] as String?,
      type: json['type'] as String?,
      registrationDate: json['registrationDate'] as String?,
    );
  }
}

class WhoisDomainResult {
  const WhoisDomainResult({
    required this.domain,
    this.handle,
    this.name,
    this.status,
    this.registrationDate,
    this.expirationDate,
    this.nameServers = const [],
  });

  final String domain;
  final String? handle;
  final String? name;
  final String? status;
  final String? registrationDate;
  final String? expirationDate;
  final List<String> nameServers;

  factory WhoisDomainResult.fromJson(Map<String, dynamic> json) {
    return WhoisDomainResult(
      domain: json['domain'] as String? ?? '',
      handle: json['handle'] as String?,
      name: json['name'] as String?,
      status: json['status'] as String?,
      registrationDate: json['registrationDate'] as String?,
      expirationDate: json['expirationDate'] as String?,
      nameServers: (json['nameServers'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}

class BlacklistHit {
  const BlacklistHit({
    required this.listId,
    required this.listName,
    required this.responseCode,
    required this.isListed,
  });

  final String listId;
  final String listName;
  final String responseCode;
  final bool isListed;

  factory BlacklistHit.fromJson(Map<String, dynamic> json) {
    return BlacklistHit(
      listId: json['listId'] as String? ?? '',
      listName: json['listName'] as String? ?? '',
      responseCode: json['responseCode'] as String? ?? '',
      isListed: json['isListed'] as bool? ?? false,
    );
  }
}

class PrivacyFlags {
  const PrivacyFlags({
    required this.address,
    required this.proxy,
    required this.hosting,
    required this.mobile,
    required this.tor,
  });

  final String address;
  final bool proxy;
  final bool hosting;
  final bool mobile;
  final bool tor;

  factory PrivacyFlags.fromJson(Map<String, dynamic> json) {
    return PrivacyFlags(
      address: json['address'] as String? ?? '',
      proxy: json['proxy'] as bool? ?? false,
      hosting: json['hosting'] as bool? ?? false,
      mobile: json['mobile'] as bool? ?? false,
      tor: json['tor'] as bool? ?? false,
    );
  }
}

class SubnetInfo {
  const SubnetInfo({
    required this.cidr,
    required this.networkAddress,
    required this.broadcastAddress,
    required this.firstHost,
    required this.lastHost,
    required this.prefixLength,
    required this.usableHosts,
  });

  final String cidr;
  final String networkAddress;
  final String broadcastAddress;
  final String firstHost;
  final String lastHost;
  final int prefixLength;
  final int usableHosts;

  factory SubnetInfo.fromJson(Map<String, dynamic> json) {
    return SubnetInfo(
      cidr: json['cidr'] as String? ?? '',
      networkAddress: json['networkAddress'] as String? ?? '',
      broadcastAddress: json['broadcastAddress'] as String? ?? '',
      firstHost: json['firstHost'] as String? ?? '',
      lastHost: json['lastHost'] as String? ?? '',
      prefixLength: json['prefixLength'] as int? ?? 0,
      usableHosts: json['usableHosts'] as int? ?? 0,
    );
  }
}

class PortCheckResult {
  const PortCheckResult({
    required this.host,
    required this.port,
    required this.isOpen,
    this.latencyMs,
    this.errorMessage,
  });

  final String host;
  final int port;
  final bool isOpen;
  final int? latencyMs;
  final String? errorMessage;

  factory PortCheckResult.fromJson(Map<String, dynamic> json) {
    return PortCheckResult(
      host: json['host'] as String? ?? '',
      port: json['port'] as int? ?? 0,
      isOpen: json['isOpen'] as bool? ?? false,
      latencyMs: json['latencyMs'] as int?,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}

class SslCertificateInfo {
  const SslCertificateInfo({
    required this.host,
    required this.port,
    required this.isValidNow,
    this.subject,
    this.issuer,
    this.notBefore,
    this.notAfter,
    this.thumbprint,
  });

  final String host;
  final int port;
  final bool isValidNow;
  final String? subject;
  final String? issuer;
  final String? notBefore;
  final String? notAfter;
  final String? thumbprint;

  factory SslCertificateInfo.fromJson(Map<String, dynamic> json) {
    return SslCertificateInfo(
      host: json['host'] as String? ?? '',
      port: json['port'] as int? ?? 443,
      isValidNow: json['isValidNow'] as bool? ?? false,
      subject: json['subject'] as String?,
      issuer: json['issuer'] as String?,
      notBefore: json['notBefore'] as String?,
      notAfter: json['notAfter'] as String?,
      thumbprint: json['thumbprint'] as String?,
    );
  }
}

class DnsRecord {
  const DnsRecord({
    required this.type,
    required this.name,
    required this.value,
    this.preference,
    this.ttl,
  });

  final String type;
  final String name;
  final String value;
  final int? preference;
  final int? ttl;

  factory DnsRecord.fromJson(Map<String, dynamic> json) {
    return DnsRecord(
      type: json['type'] as String? ?? '',
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
      preference: json['preference'] as int?,
      ttl: json['ttl'] as int?,
    );
  }
}

class DnsResolveResult {
  const DnsResolveResult({
    required this.domain,
    required this.records,
  });

  final String domain;
  final List<DnsRecord> records;

  factory DnsResolveResult.fromJson(Map<String, dynamic> json) {
    return DnsResolveResult(
      domain: json['domain'] as String? ?? '',
      records: (json['records'] as List<dynamic>?)
              ?.map((e) => DnsRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}

class DnsPropagationResolver {
  const DnsPropagationResolver({
    required this.resolverName,
    required this.values,
    required this.matchesReference,
  });

  final String resolverName;
  final List<String> values;
  final bool matchesReference;

  factory DnsPropagationResolver.fromJson(Map<String, dynamic> json) {
    return DnsPropagationResolver(
      resolverName: json['resolverName'] as String? ?? '',
      values: (json['values'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      matchesReference: json['matchesReference'] as bool? ?? false,
    );
  }
}

class DnsPropagationResult {
  const DnsPropagationResult({
    required this.domain,
    required this.recordType,
    required this.resolvers,
  });

  final String domain;
  final String recordType;
  final List<DnsPropagationResolver> resolvers;

  factory DnsPropagationResult.fromJson(Map<String, dynamic> json) {
    return DnsPropagationResult(
      domain: json['domain'] as String? ?? '',
      recordType: json['recordType'] as String? ?? 'A',
      resolvers: (json['resolvers'] as List<dynamic>?)
              ?.map((e) => DnsPropagationResolver.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
