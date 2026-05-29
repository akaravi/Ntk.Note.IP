import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ntk_note_ip_app/core/history/database/app_database.dart';
import 'package:ntk_note_ip_app/core/history/ip_history_store.dart';

void main() {
  test('add deduplicates by address and keeps newest first', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final store = IpHistoryStore(db, skipLegacyMigration: true);
    await store.add(address: '1.1.1.1', isIPv6: false, recordedAt: '2026-01-01T00:00:00Z');
    await store.add(address: '8.8.8.8', isIPv6: false, recordedAt: '2026-02-01T00:00:00Z');
    await store.add(address: '1.1.1.1', isIPv6: false, recordedAt: '2026-03-01T00:00:00Z');

    final entries = await store.getEntries();
    expect(entries.length, 2);
    expect(entries.first.address, '1.1.1.1');
    expect(entries.first.recordedAt, contains('2026-03'));
    expect(entries[1].address, '8.8.8.8');
  });

  test('clear removes all rows', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final store = IpHistoryStore(db, skipLegacyMigration: true);
    await store.add(address: '1.0.0.1', isIPv6: false);
    await store.clear();

    expect(await store.getEntries(), isEmpty);
  });
}
