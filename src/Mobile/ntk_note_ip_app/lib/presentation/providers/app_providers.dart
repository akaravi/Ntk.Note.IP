import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_token_store.dart';
import '../../core/network/api_client.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/ip_lookup_remote_datasource.dart';
import '../../data/datasources/ip_notes_remote_datasource.dart';
import '../../data/datasources/push_device_remote_datasource.dart';
import '../../core/push/fcm_token_provider.dart';
import '../../core/push/push_ip_monitor_listener.dart';
import '../../core/push/push_registration_service.dart';
import 'ipnote_client_provider.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/ip_lookup_repository_impl.dart';
import '../../data/repositories/ip_notes_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/ip_lookup_repository.dart';
import '../../domain/repositories/ip_notes_repository.dart';
import '../../domain/usecases/action_lookup_ip.dart';
import '../../domain/usecases/action_monitor_my_ip.dart';
import '../../core/ip_note_snapshot_builder.dart';
import '../../domain/usecases/add_ip_note.dart';
import '../../domain/usecases/delete_ip_note.dart';
import '../../domain/usecases/update_ip_note.dart';
import '../../domain/usecases/get_ip_details.dart';
import '../../domain/usecases/get_list_ip_lookup_records.dart';
import '../../domain/usecases/get_list_ip_notes.dart';
import '../../core/history/ip_history_sync_service.dart';
import '../../domain/usecases/get_my_ip.dart';
import 'auth_controller.dart';
import 'ip_history_provider.dart';

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) {
  return AuthTokenStore();
});

final baseApiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final apiClientProvider = Provider<ApiClient>((ref) {
  final auth = ref.watch(authControllerProvider);
  final authRepo = ref.read(authRepositoryProvider);
  final authNotifier = ref.read(authControllerProvider.notifier);

  return ApiClient(
    accessTokenProvider: () => auth.tokens?.accessToken,
    onRefreshAccessToken: () async {
      final result = await authRepo.refreshTokens();
      if (result.isSuccess && result.data != null) {
        authNotifier.applyTokens(result.data!);
        return result.data!.accessToken;
      }

      await authNotifier.logout();
      return null;
    },
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = AuthRemoteDataSource(ref.watch(ipnoteAuthClientProvider));
  return AuthRepositoryImpl(remote, ref.watch(authTokenStoreProvider));
});

final pushDeviceRemoteDataSourceProvider = Provider<PushDeviceRemoteDataSource>((ref) {
  return PushDeviceRemoteDataSource(ref.watch(ipnoteClientProvider));
});

final pushRegistrationServiceProvider = Provider<PushRegistrationService>((ref) {
  return PushRegistrationService(
    ref.watch(pushDeviceRemoteDataSourceProvider),
    FcmTokenProvider(),
  );
});

final pushIpMonitorListenerProvider = Provider<PushIpMonitorListener>((ref) {
  return PushIpMonitorListener(() async {
    if (!ref.read(authControllerProvider).isAuthenticated) {
      return;
    }

    await ref.read(actionMonitorMyIpUseCaseProvider).call();
  });
});

final ipLookupRepositoryProvider = Provider<IpLookupRepository>((ref) {
  final remote = IpLookupRemoteDataSource(ref.watch(ipnoteClientProvider));
  return IpLookupRepositoryImpl(remote);
});

final getMyIpUseCaseProvider = Provider<GetMyIpUseCase>((ref) {
  return GetMyIpUseCase(ref.watch(ipLookupRepositoryProvider));
});

final getIpDetailsUseCaseProvider = Provider<GetIpDetailsUseCase>((ref) {
  return GetIpDetailsUseCase(ref.watch(ipLookupRepositoryProvider));
});

final actionLookupIpUseCaseProvider = Provider<ActionLookupIpUseCase>((ref) {
  return ActionLookupIpUseCase(ref.watch(ipLookupRepositoryProvider));
});

final getListIpLookupRecordsUseCaseProvider =
    Provider<GetListIpLookupRecordsUseCase>((ref) {
  return GetListIpLookupRecordsUseCase(ref.watch(ipLookupRepositoryProvider));
});

final actionMonitorMyIpUseCaseProvider = Provider<ActionMonitorMyIpUseCase>((ref) {
  return ActionMonitorMyIpUseCase(ref.watch(ipLookupRepositoryProvider));
});

final ipNotesRepositoryProvider = Provider<IpNotesRepository>((ref) {
  final remote = IpNotesRemoteDataSource(ref.watch(ipnoteClientProvider));
  return IpNotesRepositoryImpl(remote);
});

final getListIpNotesUseCaseProvider = Provider<GetListIpNotesUseCase>((ref) {
  return GetListIpNotesUseCase(ref.watch(ipNotesRepositoryProvider));
});

final addIpNoteUseCaseProvider = Provider<AddIpNoteUseCase>((ref) {
  return AddIpNoteUseCase(ref.watch(ipNotesRepositoryProvider));
});

final ipNoteSnapshotBuilderProvider = Provider<IpNoteSnapshotBuilder>((ref) {
  return IpNoteSnapshotBuilder(
    getIpDetails: ref.watch(getIpDetailsUseCaseProvider),
  );
});

final deleteIpNoteUseCaseProvider = Provider<DeleteIpNoteUseCase>((ref) {
  return DeleteIpNoteUseCase(ref.watch(ipNotesRepositoryProvider));
});

final updateIpNoteUseCaseProvider = Provider<UpdateIpNoteUseCase>((ref) {
  return UpdateIpNoteUseCase(ref.watch(ipNotesRepositoryProvider));
});

final ipHistorySyncServiceProvider = Provider<IpHistorySyncService>((ref) {
  return IpHistorySyncService(
    ref.watch(ipHistoryStoreProvider),
    ref.watch(getListIpLookupRecordsUseCaseProvider),
    ref.watch(actionLookupIpUseCaseProvider),
  );
});
