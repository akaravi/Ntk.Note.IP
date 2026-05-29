import '../../domain/entities/ip_lookup_record.dart';
import '../../domain/usecases/action_lookup_ip.dart';
import '../../domain/usecases/get_list_ip_lookup_records.dart';
import 'ip_history_store.dart';

class IpHistorySyncService {
  IpHistorySyncService(
    this._historyStore,
    this._getListRecords,
    this._actionLookup,
  );

  final IpHistoryStore _historyStore;
  final GetListIpLookupRecordsUseCase _getListRecords;
  final ActionLookupIpUseCase _actionLookup;

  bool _syncedThisSession = false;

  void resetSession() {
    _syncedThisSession = false;
  }

  Future<void> syncAfterAuthentication() async {
    if (_syncedThisSession) {
      return;
    }

    final serverResult = await _getListRecords();
    if (!serverResult.isSuccess || serverResult.data == null) {
      return;
    }

    final serverRecords = serverResult.data!;
    await _mergeServerIntoLocal(serverRecords);

    final serverAddresses = serverRecords
        .map((r) => r.address.toLowerCase())
        .toSet();
    final local = await _historyStore.getEntries();
    final toUpload = local
        .where((e) => !serverAddresses.contains(e.address.toLowerCase()))
        .toList();

    for (final entry in toUpload) {
      await _actionLookup(entry.address);
    }

    _syncedThisSession = true;
  }

  Future<void> _mergeServerIntoLocal(List<IpLookupRecord> serverRecords) async {
    for (final record in serverRecords) {
      await _historyStore.add(
        address: record.address,
        isIPv6: record.address.contains(':'),
        city: record.city,
        countryCode: record.countryCode,
        recordedAt: record.created,
      );
    }
  }
}
