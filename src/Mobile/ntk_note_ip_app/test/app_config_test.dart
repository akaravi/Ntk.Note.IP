import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/config/app_config.dart';

void main() {
  test('AppConfig has non-empty api base url', () {
    expect(AppConfig.current.apiBaseUrl, isNotEmpty);
  });
}
