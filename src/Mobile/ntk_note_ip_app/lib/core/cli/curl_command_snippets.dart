import '../api/api_routes.dart';
import '../config/app_config.dart';

enum CurlCommandTabId { linux, mac, windows, powershell, mikrotik }

class CurlCommandTab {
  const CurlCommandTab({
    required this.id,
    required this.labelKey,
    required this.build,
  });

  final CurlCommandTabId id;
  final String labelKey;
  final String Function(String plainUrl) build;
}

const curlCommandTabs = <CurlCommandTab>[
  CurlCommandTab(
    id: CurlCommandTabId.linux,
    labelKey: 'cmdTabLinux',
    build: _curlPlain,
  ),
  CurlCommandTab(
    id: CurlCommandTabId.mac,
    labelKey: 'cmdTabMac',
    build: _curlPlain,
  ),
  CurlCommandTab(
    id: CurlCommandTabId.windows,
    labelKey: 'cmdTabWindows',
    build: _curlPlain,
  ),
  CurlCommandTab(
    id: CurlCommandTabId.powershell,
    labelKey: 'cmdTabPowershell',
    build: _powershellPlain,
  ),
  CurlCommandTab(
    id: CurlCommandTabId.mikrotik,
    labelKey: 'cmdTabMikrotik',
    build: _mikrotikPlain,
  ),
];

String get myIpPlainUrl =>
    ApiRoutes.myIpPlainUrl(AppConfig.current.apiBaseUrl);

String _curlPlain(String url) => 'curl -4 -s "$url"';

String _powershellPlain(String url) =>
    '(Invoke-WebRequest -Uri "$url" -UseBasicParsing).Content.Trim()';

String _mikrotikPlain(String url) =>
    '/tool fetch url="$url" mode=https keep-result=no as-value';
