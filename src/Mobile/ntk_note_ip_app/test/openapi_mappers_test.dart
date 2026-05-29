import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/api/openapi_mappers.dart';

void main() {
  test('maps MyIp from OpenAPI-shaped JSON', () {
    final myIp = OpenApiMappers.myIpFromJson({
      'address': '8.8.8.8',
      'scope': 0,
      'isIPv6': false,
    });

    expect(myIp.address, '8.8.8.8');
    expect(myIp.isIPv6, isFalse);
  });

  test('maps IpLookupRecord with DateTime created', () {
    final record = OpenApiMappers.ipLookupRecordFromJson({
      'id': 1,
      'address': '1.1.1.1',
      'created': '2026-05-30T10:00:00Z',
      'countryCode': 'US',
    });

    expect(record.id, 1);
    expect(record.address, '1.1.1.1');
    expect(record.countryCode, 'US');
    expect(record.created, contains('2026'));
  });
}
