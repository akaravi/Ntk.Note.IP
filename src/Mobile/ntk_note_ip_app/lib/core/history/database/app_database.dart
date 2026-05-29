import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '../ip_history_entry.dart';

part 'app_database.g.dart';

class IpHistoryRows extends Table {
  TextColumn get id => text()();
  TextColumn get address => text()();
  BoolColumn get isIPv6 => boolean().withDefault(const Constant(false))();
  TextColumn get recordedAt => text()();
  TextColumn get scope => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get countryCode => text().nullable()();
  TextColumn get deviceLabel => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [IpHistoryRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'ipnote_history'));

  @override
  int get schemaVersion => 1;

  Future<List<IpHistoryEntry>> loadEntries({int limit = 50}) async {
    final rows = await (select(ipHistoryRows)
          ..orderBy([(r) => OrderingTerm.desc(r.recordedAt)])
          ..limit(limit))
        .get();
    return rows.map(_toEntry).toList();
  }

  Future<void> upsertEntry(IpHistoryEntry entry, {required int maxEntries}) async {
    await transaction(() async {
      await (delete(ipHistoryRows)..where((r) => r.address.equals(entry.address)))
          .go();
      await into(ipHistoryRows).insert(
        IpHistoryRowsCompanion.insert(
          id: entry.id,
          address: entry.address,
          isIPv6: Value(entry.isIPv6),
          recordedAt: entry.recordedAt,
          scope: Value(entry.scope),
          city: Value(entry.city),
          countryCode: Value(entry.countryCode),
          deviceLabel: Value(entry.deviceLabel),
        ),
        mode: InsertMode.insertOrReplace,
      );

      final total = await countAll();
      if (total > maxEntries) {
        final overflow = await (select(ipHistoryRows)
              ..orderBy([(r) => OrderingTerm.asc(r.recordedAt)])
              ..limit(total - maxEntries))
            .get();
        for (final row in overflow) {
          await (delete(ipHistoryRows)..where((r) => r.id.equals(row.id))).go();
        }
      }
    });
  }

  Future<void> deleteById(String id) async {
    await (delete(ipHistoryRows)..where((r) => r.id.equals(id))).go();
  }

  Future<void> clearAll() async {
    await delete(ipHistoryRows).go();
  }

  Future<int> countAll() async {
    final countExpr = ipHistoryRows.id.count();
    final query = selectOnly(ipHistoryRows)..addColumns([countExpr]);
    final row = await query.getSingle();
    return row.read(countExpr) ?? 0;
  }

  IpHistoryEntry _toEntry(IpHistoryRow row) {
    return IpHistoryEntry(
      id: row.id,
      address: row.address,
      isIPv6: row.isIPv6,
      recordedAt: row.recordedAt,
      scope: row.scope,
      city: row.city,
      countryCode: row.countryCode,
      deviceLabel: row.deviceLabel,
    );
  }
}
