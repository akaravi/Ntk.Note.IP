import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/push/push_platform.dart';

void main() {
  test('pushPlatformName returns a non-empty value on VM', () {
    final name = pushPlatformName();
    expect(name.isNotEmpty, isTrue);
  });
}
