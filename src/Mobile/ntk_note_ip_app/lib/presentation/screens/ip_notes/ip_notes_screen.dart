import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/ip_note.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_providers.dart';
import 'ip_notes_controller.dart';

class IpNotesScreen extends ConsumerStatefulWidget {
  const IpNotesScreen({
    super.key,
    this.initialAddress,
    this.captureSnapshot = false,
  });

  final String? initialAddress;
  final bool captureSnapshot;

  @override
  ConsumerState<IpNotesScreen> createState() => _IpNotesScreenState();
}

class _IpNotesScreenState extends ConsumerState<IpNotesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final address = widget.initialAddress?.trim();
    if (address != null && address.isNotEmpty) {
      _addressController.text = address;
      if (widget.captureSnapshot) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(ipNotesControllerProvider.notifier).captureSnapshot(address);
        });
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final ok = await ref.read(ipNotesControllerProvider.notifier).add(
          address: _addressController.text,
          title: _titleController.text,
          body: _bodyController.text,
          tags: _tagsController.text,
        );

    if (ok && mounted) {
      _titleController.clear();
      _bodyController.clear();
      _tagsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(ipNotesControllerProvider);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notesTitle),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: () => ref.read(ipNotesControllerProvider.notifier).load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => ref.read(ipNotesControllerProvider.notifier).load(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(l10n.notesSubtitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  if (state.snapshotReady) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.noteSnapshotReady,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.primary,
                          ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _addressController,
                          decoration: InputDecoration(
                            labelText: l10n.noteAddress,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: TextButton.icon(
                            onPressed: () async {
                              final result =
                                  await ref.read(getMyIpUseCaseProvider).call();
                              if (result.isSuccess &&
                                  result.data != null &&
                                  mounted) {
                                setState(() {
                                  _addressController.text = result.data!.address;
                                });
                                await ref
                                    .read(ipNotesControllerProvider.notifier)
                                    .captureSnapshot(result.data!.address);
                              }
                            },
                            icon: const Icon(Icons.my_location),
                            label: Text(l10n.useMyIp),
                          ),
                        ),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: l10n.noteTitle,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _bodyController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: l10n.noteBody,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _tagsController,
                          decoration: InputDecoration(
                            labelText: l10n.noteTags,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        if (state.error != null) ...[
                          const SizedBox(height: 8),
                          Text(state.error!, style: TextStyle(color: scheme.error)),
                        ],
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: state.submitting ? null : _submit,
                          child: state.submitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.noteAdd),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.notesListTitle,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (state.notes.isEmpty)
                    Text(l10n.notesEmpty)
                  else
                    ...state.notes.map(
                      (note) => _NoteCard(
                        note: note,
                        l10n: l10n,
                        onEdit: () => _showEditNoteDialog(context, note),
                        onDelete: () => ref
                            .read(ipNotesControllerProvider.notifier)
                            .delete(note.id),
                        onLookup: () => context.go(
                          '/?address=${Uri.encodeComponent(note.address)}',
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Future<void> _showEditNoteDialog(BuildContext context, IpNote note) async {
    final l10n = AppLocalizations.of(context);
    final addressController = TextEditingController(text: note.address);
    final titleController = TextEditingController(text: note.title ?? '');
    final bodyController = TextEditingController(text: note.body ?? '');
    final tagsController = TextEditingController(text: note.tags ?? '');
    final formKey = GlobalKey<FormState>();

    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.noteUpdateTitle),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: l10n.noteAddress,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? l10n.fieldRequired : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: l10n.noteTitle,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: bodyController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.noteBody,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tagsController,
                    decoration: InputDecoration(
                      labelText: l10n.noteTags,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () {
                if (formKey.currentState?.validate() != true) {
                  return;
                }
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(l10n.noteSave),
            ),
          ],
        );
      },
    );

    if (saved != true || !mounted) {
      addressController.dispose();
      titleController.dispose();
      bodyController.dispose();
      tagsController.dispose();
      return;
    }

    await ref.read(ipNotesControllerProvider.notifier).update(
          id: note.id,
          address: addressController.text,
          title: titleController.text,
          body: bodyController.text,
          tags: tagsController.text,
        );

    addressController.dispose();
    titleController.dispose();
    bodyController.dispose();
    tagsController.dispose();
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.note,
    required this.l10n,
    required this.onEdit,
    required this.onDelete,
    required this.onLookup,
  });

  final IpNote note;
  final AppLocalizations l10n;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onLookup;

  @override
  Widget build(BuildContext context) {
    final when = DateTime.tryParse(note.notedWhen);
    final whenText = when != null
        ? DateFormat.yMMMd().add_Hm().format(when.toLocal())
        : note.notedWhen;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              note.address,
              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600),
            ),
            if (note.locationLine.isNotEmpty || (note.deviceLabel?.isNotEmpty ?? false))
              Text(
                [
                  if (note.locationLine.isNotEmpty) note.locationLine,
                  if (note.deviceLabel?.isNotEmpty ?? false) note.deviceLabel,
                ].join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (note.isp != null && note.isp!.isNotEmpty)
              Text(note.isp!, style: Theme.of(context).textTheme.bodySmall),
            if (note.title != null && note.title!.isNotEmpty)
              Text(note.title!, style: Theme.of(context).textTheme.titleSmall),
            if (note.body != null && note.body!.isNotEmpty) Text(note.body!),
            if (note.tagList.isNotEmpty)
              Wrap(
                spacing: 6,
                children: [
                  for (final tag in note.tagList)
                    Chip(label: Text(tag), visualDensity: VisualDensity.compact),
                ],
              ),
            Text(whenText, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton(onPressed: onLookup, child: Text(l10n.openLookup)),
                const Spacer(),
                IconButton(
                  tooltip: l10n.noteEdit,
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                ),
                IconButton(
                  tooltip: l10n.noteDelete,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
