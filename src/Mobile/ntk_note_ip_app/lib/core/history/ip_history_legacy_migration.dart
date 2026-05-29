import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'database/app_database.dart';
import 'ip_history_entry.dart';
import 'ip_history_store.dart';

const String _migrationDoneKey = 'ipnote.history.drift_migrated';

/// One-time import from legacy SharedPreferences JSON blob.
Future<void> migrateLegacyIpHistoryIfNeeded(AppDatabase database) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(_migrationDoneKey) == true) {
    return;
  }

  final raw = prefs.getString(ipHistoryStorageKey);
  if (raw != null && raw.isNotEmpty) {
    try {
      final parsed = jsonDecode(raw) as Map<String, dynamic>;
      final list = parsed['entries'];
      if (list is List) {
        for (final item in list.whereType<Map>()) {
          final entry = IpHistoryEntry.fromJson(item.cast<String, dynamic>());
          if (entry.address.isEmpty) {
            continue;
          }

          await database.upsertEntry(entry, maxEntries: ipHistoryMaxEntries);
        }
      }
    } catch (_) {
      // Ignore corrupt legacy payload.
    }
  }

  await prefs.setBool(_migrationDoneKey, true);
  await prefs.remove(ipHistoryStorageKey);
}
