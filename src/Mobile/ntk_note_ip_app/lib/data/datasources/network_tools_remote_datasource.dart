import 'package:dio/dio.dart';

import '../../core/network/api_result.dart';
import '../../domain/entities/network_tools.dart';

class NetworkToolsRemoteDataSource {
  NetworkToolsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ApiResult<WhoisIpResult>> getWhoisIp(String address) {
    return _getObject(
      '/api/v1/Whois/GetWhoisIp',
      {'address': address},
      WhoisIpResult.fromJson,
    );
  }

  Future<ApiResult<WhoisDomainResult>> getWhoisDomain(String domain) {
    return _getObject(
      '/api/v1/Whois/GetWhoisDomain',
      {'domain': domain},
      WhoisDomainResult.fromJson,
    );
  }

  Future<ApiResult<List<BlacklistHit>>> getBlacklist(String address) {
    return _getList(
      '/api/v1/Blacklist/GetList',
      {'address': address},
      BlacklistHit.fromJson,
    );
  }

  Future<ApiResult<PrivacyFlags>> getPrivacyFlags(String address) {
    return _getObject(
      '/api/v1/IpTools/GetPrivacyFlags',
      {'address': address},
      PrivacyFlags.fromJson,
    );
  }

  Future<ApiResult<SubnetInfo>> calculateSubnet(String cidr) {
    return _getObject(
      '/api/v1/IpTools/ActionCalculateSubnet',
      {'cidr': cidr},
      SubnetInfo.fromJson,
    );
  }

  Future<ApiResult<PortCheckResult>> checkPort(String host, int port) {
    return _getObject(
      '/api/v1/IpTools/ActionCheckPort',
      {'host': host, 'port': port.toString()},
      PortCheckResult.fromJson,
    );
  }

  Future<ApiResult<SslCertificateInfo>> getSslCertificate(
    String domain, {
    int port = 443,
  }) {
    return _getObject(
      '/api/v1/IpTools/GetSslCertificateInfo',
      {'domain': domain, 'port': port.toString()},
      SslCertificateInfo.fromJson,
    );
  }

  Future<ApiResult<DnsResolveResult>> resolveDns(String domain) {
    return _getObject(
      '/api/v1/Dns/ResolveDns',
      {'domain': domain},
      DnsResolveResult.fromJson,
    );
  }

  Future<ApiResult<DnsPropagationResult>> getDnsPropagation(
    String domain, {
    String type = 'A',
  }) {
    return _getObject(
      '/api/v1/Dns/GetListDnsPropagation',
      {'domain': domain, 'type': type},
      DnsPropagationResult.fromJson,
    );
  }

  Future<ApiResult<T>> _getObject<T>(
    String path,
    Map<String, String> query,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return _unwrap(response.data, fromJson);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  Future<ApiResult<List<T>>> _getList<T>(
    String path,
    Map<String, String> query,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      final envelope = response.data;
      if (envelope == null) {
        return ApiResult.fail('Empty response');
      }

      if (envelope['isSuccess'] != true) {
        return ApiResult.fail(envelope['errorMessage'] as String? ?? 'Request failed');
      }

      final data = envelope['data'];
      if (data is! List) {
        return ApiResult.ok(const []);
      }

      final items = data
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
      return ApiResult.ok(items);
    } catch (error) {
      return ApiResult.fail(error.toString());
    }
  }

  ApiResult<T> _unwrap<T>(
    Map<String, dynamic>? envelope,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (envelope == null) {
      return ApiResult.fail('Empty response');
    }

    if (envelope['isSuccess'] != true) {
      return ApiResult.fail(envelope['errorMessage'] as String? ?? 'Request failed');
    }

    final data = envelope['data'];
    if (data is! Map<String, dynamic>) {
      return ApiResult.fail('Invalid response data');
    }

    return ApiResult.ok(fromJson(data));
  }
}
