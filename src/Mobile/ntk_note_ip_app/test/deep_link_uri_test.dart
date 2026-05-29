import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/navigation/deep_link_uri.dart';

void main() {
  group('mapWebDeepLinkToAppPath', () {
    test('maps ip-lookup with address to home query', () {
      final uri = Uri.parse('https://ipnote.ir/ip-lookup?address=8.8.8.8');
      expect(mapWebDeepLinkToAppPath(uri), '/?address=8.8.8.8');
    });

    test('maps bare ip-lookup to home', () {
      expect(
        mapWebDeepLinkToAppPath(Uri.parse('https://ipnote.ir/ip-lookup')),
        '/',
      );
    });

    test('preserves dashboard path', () {
      expect(
        mapWebDeepLinkToAppPath(Uri.parse('https://ipnote.ir/dashboard')),
        '/dashboard',
      );
    });

    test('ignores unknown hosts', () {
      expect(
        mapWebDeepLinkToAppPath(Uri.parse('https://example.com/dashboard')),
        isNull,
      );
    });
  });
}
