import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/history/database/app_database.dart';
import '../../core/history/ip_history_entry.dart';
import '../../core/history/ip_history_store.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final ipHistoryStoreProvider = Provider<IpHistoryStore>((ref) {
  return IpHistoryStore(ref.watch(appDatabaseProvider));
});

final ipHistoryListProvider = FutureProvider<List<IpHistoryEntry>>((ref) async {
  return ref.watch(ipHistoryStoreProvider).getEntries();
});
