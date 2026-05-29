import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/generated/clients/ipnote_client.dart';
import 'app_providers.dart';

final ipnoteClientProvider = Provider<IpnoteClient>((ref) {
  final dio = ref.watch(apiClientProvider).dio;
  return IpnoteClient(dio, baseUrl: dio.options.baseUrl);
});

/// Unauthenticated client for login/register (no Bearer interceptor).
final ipnoteAuthClientProvider = Provider<IpnoteClient>((ref) {
  final dio = ref.watch(baseApiClientProvider).dio;
  return IpnoteClient(dio, baseUrl: dio.options.baseUrl);
});
