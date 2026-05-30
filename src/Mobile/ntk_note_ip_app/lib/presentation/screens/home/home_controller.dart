import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/device/device_info_summary.dart';
import '../../../core/feedback/app_haptics.dart';
import '../../../core/network/local_ip_service.dart';
import '../../../core/widget/ip_home_widget_service.dart';
import '../../../domain/entities/ip_details.dart';
import '../../../domain/entities/my_ip.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_controller.dart';
import '../../providers/ip_history_provider.dart';

class HomeState {
  const HomeState({
    this.loading = false,
    this.detailsLoading = false,
    this.myIp,
    this.details,
    this.error,
    this.copied = false,
    this.plainCopied = false,
    this.showQr = false,
    this.localIp,
    this.deviceInfo,
    this.lookupAddress = '',
  });

  final bool loading;
  final bool detailsLoading;
  final MyIp? myIp;
  final IpDetails? details;
  final String? error;
  final bool copied;
  final bool plainCopied;
  final bool showQr;
  final String? localIp;
  final DeviceInfoSummary? deviceInfo;
  final String lookupAddress;

  HomeState copyWith({
    bool? loading,
    bool? detailsLoading,
    MyIp? myIp,
    IpDetails? details,
    String? error,
    bool? copied,
    bool? plainCopied,
    bool? showQr,
    String? localIp,
    DeviceInfoSummary? deviceInfo,
    String? lookupAddress,
    bool clearError = false,
    bool clearDetails = false,
  }) {
    return HomeState(
      loading: loading ?? this.loading,
      detailsLoading: detailsLoading ?? this.detailsLoading,
      myIp: myIp ?? this.myIp,
      details: clearDetails ? null : (details ?? this.details),
      error: clearError ? null : (error ?? this.error),
      copied: copied ?? this.copied,
      plainCopied: plainCopied ?? this.plainCopied,
      showQr: showQr ?? this.showQr,
      localIp: localIp ?? this.localIp,
      deviceInfo: deviceInfo ?? this.deviceInfo,
      lookupAddress: lookupAddress ?? this.lookupAddress,
    );
  }
}

class HomeController extends Notifier<HomeState> {
  final _localIpService = LocalIpService();
  Timer? _liveIpTimer;

  @override
  HomeState build() {
    Future.microtask(_bootstrap);
    _liveIpTimer?.cancel();
    _liveIpTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => _pollLiveIp(),
    );
    ref.onDispose(() => _liveIpTimer?.cancel());
    return const HomeState(loading: true);
  }

  Future<void> _pollLiveIp() async {
    final result = await ref.read(getMyIpUseCaseProvider).call();
    if (!result.isSuccess || result.data == null) {
      return;
    }

    final newIp = result.data!;
    final current = state.myIp?.address;
    if (current == null || current == newIp.address) {
      return;
    }

    state = state.copyWith(myIp: newIp, lookupAddress: newIp.address);
    await _loadDetails(newIp.address, syncServer: true);
  }

  Future<void> _bootstrap() async {
    final deviceFuture = DeviceInfoSummary.load();
    final localIpFuture = _localIpService.discoverLocalIpv4();
    await load();
    final device = await deviceFuture;
    final localIp = await localIpFuture;
    state = state.copyWith(deviceInfo: device, localIp: localIp);
  }

  Future<void> load() async {
    state = state.copyWith(
      loading: true,
      clearError: true,
      copied: false,
      plainCopied: false,
      showQr: false,
    );

    final result = await ref.read(getMyIpUseCaseProvider).call();
    if (!result.isSuccess || result.data == null) {
      state = state.copyWith(
        loading: false,
        error: result.errorMessage ?? 'Error',
      );
      return;
    }

    final myIp = result.data!;
    state = state.copyWith(
      loading: false,
      myIp: myIp,
      lookupAddress: myIp.address,
    );
    await _loadDetails(myIp.address, syncServer: true);
  }

  Future<void> lookupExternal(String address) async {
    state = state.copyWith(lookupAddress: address.trim());
    await lookupAddress();
  }

  Future<void> lookupAddress() async {
    final address = state.lookupAddress.trim();
    if (address.isEmpty) {
      return;
    }

    state = state.copyWith(loading: true, clearError: true, clearDetails: true);
    await _loadDetails(address, syncServer: true);
    state = state.copyWith(loading: false);
  }

  void setLookupAddress(String value) {
    state = state.copyWith(lookupAddress: value);
  }

  Future<void> _loadDetails(String address, {required bool syncServer}) async {
    state = state.copyWith(detailsLoading: true, clearDetails: true);

    final detailsResult =
        await ref.read(getIpDetailsUseCaseProvider).call(address);
    if (!detailsResult.isSuccess || detailsResult.data == null) {
      state = state.copyWith(
        detailsLoading: false,
        error: detailsResult.errorMessage ?? 'Error',
      );
      return;
    }

    final details = detailsResult.data!;
    state = state.copyWith(
      detailsLoading: false,
      details: details,
      myIp: MyIp(
        address: details.address,
        scope: details.scope,
        isIPv6: details.isIPv6,
      ),
    );

    try {
      await ref.read(ipHistoryStoreProvider).add(
            address: details.address,
            isIPv6: details.isIPv6,
            scope: details.scope,
            city: details.geo.city,
            countryCode: details.geo.countryCode,
            deviceLabel: state.deviceInfo?.label,
          );
      ref.invalidate(ipHistoryListProvider);
    } catch (_) {
      // Local history is best-effort; do not break home when storage fails on web.
    }

    await IpHomeWidgetService.sync(
      address: details.address,
      scope: details.scope,
      isIPv6: details.isIPv6,
      city: details.geo.city,
      countryCode: details.geo.countryCode,
    );

    if (syncServer && ref.read(authControllerProvider).isAuthenticated) {
      await ref.read(actionLookupIpUseCaseProvider).call(address);
    }
  }

  Future<void> copyAddress() async {
    final ip = state.myIp?.address;
    if (ip == null || ip.isEmpty) {
      return;
    }

    await Clipboard.setData(ClipboardData(text: ip));
    await AppHaptics.light();
    state = state.copyWith(copied: true);
    await Future<void>.delayed(const Duration(seconds: 2));
    state = state.copyWith(copied: false);
  }

  Future<void> copyPlainIp() async {
    final result = await ref.read(getMyIpPlainUseCaseProvider).call();
    if (!result.isSuccess || result.data == null) {
      state = state.copyWith(error: result.errorMessage ?? 'Error');
      return;
    }

    try {
      await Clipboard.setData(ClipboardData(text: result.data!.trim()));
      await AppHaptics.light();
      state = state.copyWith(plainCopied: true);
      await Future<void>.delayed(const Duration(seconds: 2));
      state = state.copyWith(plainCopied: false);
    } catch (error) {
      state = state.copyWith(error: error.toString());
    }
  }

  void toggleQr() {
    state = state.copyWith(showQr: !state.showQr);
  }
}

final homeControllerProvider =
    NotifierProvider<HomeController, HomeState>(HomeController.new);
