import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/background/ip_change_detector.dart';

void main() {
  test('returns null when current address is empty', () {
    expect(
      detectPublicIpChange(previousAddress: '1.1.1.1', currentAddress: ''),
      isNull,
    );
  });

  test('returns null on first sample (no previous)', () {
    expect(
      detectPublicIpChange(previousAddress: null, currentAddress: '8.8.8.8'),
      isNull,
    );
  });

  test('returns null when unchanged', () {
    expect(
      detectPublicIpChange(previousAddress: '1.1.1.1', currentAddress: '1.1.1.1'),
      isNull,
    );
  });

  test('returns new address when changed', () {
    expect(
      detectPublicIpChange(previousAddress: '1.1.1.1', currentAddress: '8.8.8.8'),
      '8.8.8.8',
    );
  });
}
