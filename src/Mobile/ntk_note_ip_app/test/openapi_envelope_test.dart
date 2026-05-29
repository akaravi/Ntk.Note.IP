import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/network/openapi_envelope.dart';

void main() {
  test('mapData succeeds when isSuccess and data present', () {
    final result = OpenApiEnvelope.mapData(
      isSuccess: true,
      errorMessage: null,
      data: {'address': '1.1.1.1'},
    );
    expect(result.isSuccess, isTrue);
    expect(result.data?['address'], '1.1.1.1');
  });

  test('mapData fails when isSuccess is false', () {
    final result = OpenApiEnvelope.mapData<String>(
      isSuccess: false,
      errorMessage: 'Denied',
      data: 'x',
    );
    expect(result.isSuccess, isFalse);
    expect(result.errorMessage, 'Denied');
  });
}
