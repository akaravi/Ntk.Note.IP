import 'dart:convert';

import '../../core/history/ip_history_entry.dart';
import '../entities/ip_lookup_record.dart';
import '../entities/ip_note.dart';

enum DashboardTimelineKind { lookup, note }

class DashboardTimelineItem {
  const DashboardTimelineItem({
    required this.id,
    required this.kind,
    required this.address,
    required this.recordedAt,
    this.city,
    this.countryCode,
    this.deviceLabel,
    this.title,
    this.body,
    this.tags,
  });

  final String id;
  final DashboardTimelineKind kind;
  final String address;
  final String recordedAt;
  final String? city;
  final String? countryCode;
  final String? deviceLabel;
  final String? title;
  final String? body;
  final String? tags;
}

class DashboardStats {
  const DashboardStats({
    required this.total,
    required this.uniqueAddresses,
    required this.uniqueCountries,
    required this.noteCount,
  });

  final int total;
  final int uniqueAddresses;
  final int uniqueCountries;
  final int noteCount;
}

class CountryCount {
  const CountryCount({required this.code, required this.count});

  final String code;
  final int count;
}

List<DashboardTimelineItem> buildDashboardTimeline({
  required List<IpHistoryEntry> localHistory,
  required List<IpLookupRecord> serverRecords,
  List<IpNote> notes = const [],
}) {
  final lookupByAddress = <String, DashboardTimelineItem>{};

  void upsertLookup(DashboardTimelineItem item) {
    final key = item.address.toLowerCase();
    final existing = lookupByAddress[key];
    if (existing == null || _isAfter(item.recordedAt, existing.recordedAt)) {
      lookupByAddress[key] = item;
    }
  }

  for (final entry in localHistory) {
    upsertLookup(
      DashboardTimelineItem(
        id: 'local-${entry.id}',
        kind: DashboardTimelineKind.lookup,
        address: entry.address,
        recordedAt: entry.recordedAt,
        city: entry.city,
        countryCode: entry.countryCode,
        deviceLabel: entry.deviceLabel,
      ),
    );
  }

  for (final record in serverRecords) {
    upsertLookup(
      DashboardTimelineItem(
        id: 'server-${record.id}',
        kind: DashboardTimelineKind.lookup,
        address: record.address,
        recordedAt: record.created,
        city: record.city,
        countryCode: record.countryCode,
      ),
    );
  }

  final noteItems = notes
      .map(
        (note) => DashboardTimelineItem(
          id: 'note-${note.id}',
          kind: DashboardTimelineKind.note,
          address: note.address,
          recordedAt: note.created,
          title: note.title,
          body: note.body,
          tags: note.tags,
        ),
      )
      .toList();

  final items = [...lookupByAddress.values, ...noteItems]
    ..sort((a, b) => _compareRecordedAt(b.recordedAt, a.recordedAt));

  return items;
}

String exportTimelineCsv(List<DashboardTimelineItem> items) {
  const header =
      'kind,address,recordedAt,city,countryCode,deviceLabel,title,tags';
  final rows = items.map((item) {
    final values = [
      item.kind.name,
      item.address,
      item.recordedAt,
      item.city ?? '',
      item.countryCode ?? '',
      item.deviceLabel ?? '',
      item.title ?? '',
      item.tags ?? '',
    ];

    return values.map(_csvEscape).join(',');
  });

  return [header, ...rows].join('\n');
}

String exportTimelineJson(List<DashboardTimelineItem> items) {
  final encoded = items
      .map(
        (item) => {
          'kind': item.kind.name,
          'address': item.address,
          'recordedAt': item.recordedAt,
          'city': item.city,
          'countryCode': item.countryCode,
          'deviceLabel': item.deviceLabel,
          'title': item.title,
          'body': item.body,
          'tags': item.tags,
        },
      )
      .toList();

  return const JsonEncoder.withIndent('  ').convert(encoded);
}

String _csvEscape(String value) => '"${value.replaceAll('"', '""')}"';

bool _isAfter(String a, String b) => _compareRecordedAt(a, b) > 0;

int _compareRecordedAt(String a, String b) {
  final da = DateTime.tryParse(a);
  final db = DateTime.tryParse(b);
  if (da == null || db == null) {
    return b.compareTo(a);
  }

  return da.compareTo(db);
}

List<DashboardTimelineItem> filterTimeline({
  required List<DashboardTimelineItem> items,
  required String search,
  required String countryCode,
}) {
  final query = search.trim().toLowerCase();
  return items.where((item) {
    if (countryCode.isNotEmpty &&
        (item.countryCode ?? '').toUpperCase() != countryCode.toUpperCase()) {
      return false;
    }

    if (query.isEmpty) {
      return true;
    }

    final haystack = [
      item.address,
      item.city,
      item.countryCode,
      item.deviceLabel,
      item.title,
      item.body,
      item.tags,
    ].whereType<String>().join(' ').toLowerCase();

    return haystack.contains(query);
  }).toList();
}

DashboardStats computeDashboardStats(List<DashboardTimelineItem> items) {
  final addresses = <String>{};
  final countries = <String>{};
  var noteCount = 0;

  for (final item in items) {
    addresses.add(item.address.toLowerCase());
    if (item.countryCode != null && item.countryCode!.isNotEmpty) {
      countries.add(item.countryCode!.toUpperCase());
    }
    if (item.kind == DashboardTimelineKind.note) {
      noteCount += 1;
    }
  }

  return DashboardStats(
    total: items.length,
    uniqueAddresses: addresses.length,
    uniqueCountries: countries.length,
    noteCount: noteCount,
  );
}

List<CountryCount> computeCountryBreakdown(List<DashboardTimelineItem> items) {
  final counts = <String, int>{};

  for (final item in items) {
    final code = item.countryCode;
    if (code == null || code.isEmpty) {
      continue;
    }

    final upper = code.toUpperCase();
    counts[upper] = (counts[upper] ?? 0) + 1;
  }

  return counts.entries
      .map((e) => CountryCount(code: e.key, count: e.value))
      .toList()
    ..sort((a, b) => b.count.compareTo(a.count));
}
