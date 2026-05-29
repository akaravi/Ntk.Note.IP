import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/ip_note.dart';
import '../../../domain/entities/ip_note_add_snapshot.dart';
import '../../providers/app_providers.dart';

class IpNotesState {
  const IpNotesState({
    this.loading = false,
    this.submitting = false,
    this.notes = const [],
    this.error,
    this.snapshotReady = false,
  });

  final bool loading;
  final bool submitting;
  final List<IpNote> notes;
  final String? error;
  final bool snapshotReady;

  IpNotesState copyWith({
    bool? loading,
    bool? submitting,
    List<IpNote>? notes,
    String? error,
    bool? snapshotReady,
    bool clearError = false,
  }) {
    return IpNotesState(
      loading: loading ?? this.loading,
      submitting: submitting ?? this.submitting,
      notes: notes ?? this.notes,
      error: clearError ? null : (error ?? this.error),
      snapshotReady: snapshotReady ?? this.snapshotReady,
    );
  }
}

class IpNotesController extends Notifier<IpNotesState> {
  IpNoteAddSnapshot? _pendingSnapshot;

  @override
  IpNotesState build() {
    Future.microtask(load);
    return const IpNotesState(loading: true);
  }

  Future<void> captureSnapshot(String address) async {
    state = state.copyWith(snapshotReady: false, clearError: true);
    try {
      _pendingSnapshot =
          await ref.read(ipNoteSnapshotBuilderProvider).buildForAddress(address);
      state = state.copyWith(snapshotReady: true);
    } catch (_) {
      _pendingSnapshot = null;
      state = state.copyWith(snapshotReady: false);
    }
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);
    final result = await ref.read(getListIpNotesUseCaseProvider).call();
    if (result.isSuccess && result.data != null) {
      state = IpNotesState(notes: result.data!);
      return;
    }

    state = state.copyWith(
      loading: false,
      error: result.errorMessage ?? 'Error',
    );
  }

  Future<bool> add({
    required String address,
    String? title,
    String? body,
    String? tags,
  }) async {
    state = state.copyWith(submitting: true, clearError: true);
    final result = await ref.read(addIpNoteUseCaseProvider).call(
          address: address.trim(),
          title: title?.trim(),
          body: body?.trim(),
          tags: tags?.trim(),
          snapshot: _pendingSnapshot,
        );

    if (!result.isSuccess) {
      state = state.copyWith(
        submitting: false,
        error: result.errorMessage ?? 'Error',
      );
      return false;
    }

    _pendingSnapshot = null;
    await load();
    state = state.copyWith(submitting: false, snapshotReady: false);
    return true;
  }

  Future<bool> update({
    required int id,
    required String address,
    String? title,
    String? body,
    String? tags,
  }) async {
    state = state.copyWith(submitting: true, clearError: true);
    final result = await ref.read(updateIpNoteUseCaseProvider).call(
          id: id,
          address: address.trim(),
          title: title?.trim(),
          body: body?.trim(),
          tags: tags?.trim(),
        );

    if (!result.isSuccess) {
      state = state.copyWith(
        submitting: false,
        error: result.errorMessage ?? 'Error',
      );
      return false;
    }

    await load();
    state = state.copyWith(submitting: false);
    return true;
  }

  Future<void> delete(int id) async {
    final result = await ref.read(deleteIpNoteUseCaseProvider).call(id);
    if (result.isSuccess) {
      await load();
      return;
    }

    state = state.copyWith(error: result.errorMessage ?? 'Error');
  }

}

final ipNotesControllerProvider =
    NotifierProvider<IpNotesController, IpNotesState>(IpNotesController.new);
