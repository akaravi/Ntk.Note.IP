import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/feedback/app_review_service.dart';
import '../../../core/map/osm_static_map.dart';
import '../../../domain/dashboard/dashboard_timeline.dart';
import '../../../domain/entities/ip_lookup_record.dart';
import '../../../domain/entities/ip_note.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_controller.dart';
import '../../providers/ip_history_provider.dart';

class DashboardState {
  const DashboardState({
    this.loading = false,
    this.error,
    this.search = '',
    this.countryFilter = '',
    this.allItems = const [],
    this.mapUrl,
    this.mapLoading = false,
  });

  final bool loading;
  final String? error;
  final String search;
  final String countryFilter;
  final List<DashboardTimelineItem> allItems;
  final String? mapUrl;
  final bool mapLoading;

  List<DashboardTimelineItem> get filteredItems => filterTimeline(
        items: allItems,
        search: search,
        countryCode: countryFilter,
      );

  DashboardStats get stats => computeDashboardStats(filteredItems);

  List<CountryCount> get countryBreakdown =>
      computeCountryBreakdown(filteredItems);

  DashboardState copyWith({
    bool? loading,
    String? error,
    String? search,
    String? countryFilter,
    List<DashboardTimelineItem>? allItems,
    String? mapUrl,
    bool? mapLoading,
    bool clearError = false,
    bool clearMap = false,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      search: search ?? this.search,
      countryFilter: countryFilter ?? this.countryFilter,
      allItems: allItems ?? this.allItems,
      mapUrl: clearMap ? null : (mapUrl ?? this.mapUrl),
      mapLoading: mapLoading ?? this.mapLoading,
    );
  }
}

class DashboardController extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.microtask(load);
    return const DashboardState(loading: true);
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true, clearMap: true);

    try {
      final local = await ref.read(ipHistoryStoreProvider).getEntries();
      var server = <IpLookupRecord>[];
      var notes = <IpNote>[];

      if (ref.read(authControllerProvider).isAuthenticated) {
        unawaited(ref.read(actionMonitorMyIpUseCaseProvider).call());

        final serverResult =
            await ref.read(getListIpLookupRecordsUseCaseProvider).call();
        if (serverResult.isSuccess && serverResult.data != null) {
          server = serverResult.data!;
        }

        final notesResult = await ref.read(getListIpNotesUseCaseProvider).call();
        if (notesResult.isSuccess && notesResult.data != null) {
          notes = notesResult.data!;
        }
      }

      final items = buildDashboardTimeline(
        localHistory: local,
        serverRecords: server,
        notes: notes,
      );

      state = DashboardState(allItems: items);
      await _loadAggregateMap(items);
      await appReviewServiceProvider.recordDashboardVisitAndMaybePrompt();
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> _loadAggregateMap(List<DashboardTimelineItem> items) async {
    final addresses = items
        .where((item) => item.kind == DashboardTimelineKind.lookup)
        .map((item) => item.address)
        .toSet()
        .take(12)
        .toList();

    if (addresses.isEmpty) {
      return;
    }

    state = state.copyWith(mapLoading: true);

    final markers = <GeoMarker>[];
    for (final address in addresses) {
      final details =
          await ref.read(getIpDetailsUseCaseProvider).call(address);
      if (!details.isSuccess || details.data == null) {
        continue;
      }

      final geo = details.data!.geo;
      if (geo.hasCoordinates) {
        markers.add(GeoMarker(lat: geo.latitude!, lon: geo.longitude!));
      }
    }

    state = state.copyWith(
      mapLoading: false,
      mapUrl: OsmStaticMap.buildAggregateMapUrl(markers),
    );
  }

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void toggleCountryFilter(String code) {
    state = state.copyWith(
      countryFilter: state.countryFilter == code ? '' : code,
    );
  }

  Future<void> exportCsv() async {
    await Share.share(
      exportTimelineCsv(state.filteredItems),
      subject: 'ipnote-dashboard.csv',
    );
  }

  Future<void> exportJson() async {
    await Share.share(
      exportTimelineJson(state.filteredItems),
      subject: 'ipnote-dashboard.json',
    );
  }
}

final dashboardControllerProvider =
    NotifierProvider<DashboardController, DashboardState>(
  DashboardController.new,
);
