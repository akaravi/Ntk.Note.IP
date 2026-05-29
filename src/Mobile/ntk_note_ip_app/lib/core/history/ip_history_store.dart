import 'package:uuid/uuid.dart';

import 'database/app_database.dart';
import 'ip_history_entry.dart';
import 'ip_history_legacy_migration.dart';

const int ipHistorySchemaVersion = 2;
const String ipHistoryStorageKey = 'ipnote.ip-history';
const int ipHistoryMaxEntries = 50;

class IpHistoryStore {
  IpHistoryStore(this._database, {bool skipLegacyMigration = false})
      : _skipLegacyMigration = skipLegacyMigration;

  final AppDatabase _database;
  final bool _skipLegacyMigration;
  bool _ready = false;

  Future<void> _ensureReady() async {
    if (_ready) {
      return;
    }

    if (!_skipLegacyMigration) {
      await migrateLegacyIpHistoryIfNeeded(_database);
    }
    _ready = true;
  }

  Future<List<IpHistoryEntry>> getEntries() async {
    await _ensureReady();
    return _database.loadEntries(limit: ipHistoryMaxEntries);
  }

  Future<void> add({
    required String address,
    required bool isIPv6,
    String? scope,
    String? city,
    String? countryCode,
    String? deviceLabel,
    String? recordedAt,
  }) async {
    await _ensureReady();
    final entry = IpHistoryEntry(
      id: const Uuid().v4(),
      address: address,
      isIPv6: isIPv6,
      scope: scope,
      recordedAt: recordedAt ?? DateTime.now().toUtc().toIso8601String(),
      city: city,
      countryCode: countryCode,
      deviceLabel: deviceLabel,
    );

    await _database.upsertEntry(entry, maxEntries: ipHistoryMaxEntries);
  }

  Future<void> remove(String id) async {
    await _ensureReady();
    await _database.deleteById(id);
  }

  Future<void> clear() async {
    await _ensureReady();
    await _database.clearAll();
  }
}
