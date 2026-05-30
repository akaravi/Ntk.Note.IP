import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/presentation/widgets/ltr_technical_text.dart';

void main() {
  test('isLatinTechnicalText accepts curl commands and IPs', () {
    expect(
      isLatinTechnicalText('curl -4 -s "http://localhost/api"'),
      isTrue,
    );
    expect(isLatinTechnicalText('203.0.113.1'), isTrue);
    expect(isLatinTechnicalText('Linux'), isTrue);
  });

  test('isLatinTechnicalText rejects Persian text', () {
    expect(isLatinTechnicalText('تهران'), isFalse);
    expect(isLatinTechnicalText('IP: 1.1.1.1'), isTrue);
  });
}
