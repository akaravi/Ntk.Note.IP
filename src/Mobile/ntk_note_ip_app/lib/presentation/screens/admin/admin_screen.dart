import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/datasources/admin_remote_datasource.dart';
import '../../../domain/entities/admin_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/admin_access_provider.dart';
import '../../widgets/app_scaffold.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  var _loading = false;
  String? _error;
  AdminDashboardStats? _dashboard;
  List<AdminRole> _roles = const [];
  List<AdminPermissionCatalogItem> _permissionCatalog = const [];
  List<AdminUser> _users = const [];
  List<AdminIpNoteItem> _notes = const [];
  List<AdminIpLookupItem> _lookups = const [];
  List<AdminPushDevice> _pushDevices = const [];
  List<AdminOutboxMessage> _outbox = const [];
  List<AdminSupportTicket> _tickets = const [];
  var _pendingOnly = false;
  var _ticketsOpenOnly = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 8, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) {
        _loadTab(_tabs.index);
      }
    });
    Future.microtask(() => _loadTab(0));
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  AdminRemoteDataSource get _admin => ref.read(adminRemoteDataSourceProvider);

  Future<void> _loadTab(int index) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      switch (index) {
        case 0:
          final r = await _admin.getDashboard();
          if (r.isSuccess) {
            _dashboard = r.data;
          } else {
            _error = r.errorMessage;
          }
        case 1:
          final rolesResult = await _admin.getRoles();
          final catalogResult = await _admin.getPermissionCatalog();
          if (rolesResult.isSuccess) {
            _roles = rolesResult.data ?? const [];
          } else {
            _error = rolesResult.errorMessage;
          }
          if (catalogResult.isSuccess) {
            _permissionCatalog = catalogResult.data ?? const [];
          }
        case 2:
          final r = await _admin.getUsers();
          if (r.isSuccess) {
            _users = r.data ?? const [];
          } else {
            _error = r.errorMessage;
          }
        case 3:
          final r = await _admin.getIpNotes();
          if (r.isSuccess) {
            _notes = r.data ?? const [];
          } else {
            _error = r.errorMessage;
          }
        case 4:
          final r = await _admin.getIpLookups();
          if (r.isSuccess) {
            _lookups = r.data ?? const [];
          } else {
            _error = r.errorMessage;
          }
        case 5:
          final r = await _admin.getPushDevices();
          if (r.isSuccess) {
            _pushDevices = r.data ?? const [];
          } else {
            _error = r.errorMessage;
          }
        case 6:
          final r = await _admin.getOutbox(pendingOnly: _pendingOnly);
          if (r.isSuccess) {
            _outbox = r.data ?? const [];
          } else {
            _error = r.errorMessage;
          }
        case 7:
          final r = await _admin.getSupportTickets(openOnly: _ticketsOpenOnly);
          if (r.isSuccess) {
            _tickets = r.data ?? const [];
          } else {
            _error = r.errorMessage;
          }
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _confirmDelete(Future<void> Function() action) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.adminConfirmDelete),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.actionCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.noteDelete)),
        ],
      ),
    );
    if (ok == true) {
      await action();
      await _loadTab(_tabs.index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final access = ref.watch(adminAccessProvider);

    if (access.isLoading) {
      return AppScaffold(
        title: l10n.adminTitle,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (access.valueOrNull?.isAdministrator != true) {
      return AppScaffold(
        title: l10n.adminTitle,
        body: Center(child: Text(l10n.adminAccessDenied)),
      );
    }

    return AppScaffold(
      title: l10n.adminTitle,
      actions: [
        IconButton(
          tooltip: l10n.adminBackToApp,
          onPressed: () => context.go('/dashboard'),
          icon: const Icon(Icons.arrow_back),
        ),
      ],
      body: Column(
        children: [
          TabBar(
            controller: _tabs,
            isScrollable: true,
            tabs: [
              Tab(text: l10n.adminNavDashboard),
              Tab(text: l10n.adminNavRoles),
              Tab(text: l10n.adminNavUsers),
              Tab(text: l10n.adminNavNotes),
              Tab(text: l10n.adminNavLookups),
              Tab(text: l10n.adminNavPush),
              Tab(text: l10n.adminNavOutbox),
              Tab(text: l10n.adminTicketsTab),
            ],
          ),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _buildDashboard(l10n),
                _buildRoles(l10n),
                _buildUsers(l10n),
                _buildNotes(l10n),
                _buildLookups(l10n),
                _buildPush(l10n),
                _buildOutbox(l10n),
                _buildTickets(l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboard(AppLocalizations l10n) {
    final stats = _dashboard;
    if (stats == null) {
      return Center(child: Text(l10n.dashboardEmpty));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _StatTile(label: l10n.adminStatUsers, value: stats.userCount),
        _StatTile(label: l10n.adminStatRoles, value: stats.roleCount),
        _StatTile(label: l10n.adminStatNotes, value: stats.ipNoteCount),
        _StatTile(label: l10n.adminStatLookups, value: stats.ipLookupRecordCount),
        _StatTile(label: l10n.adminStatPush, value: stats.pushDeviceCount),
        _StatTile(label: l10n.adminStatOutbox, value: stats.outboxPendingCount),
        _StatTile(label: l10n.adminStatTicketsOpen, value: stats.supportTicketOpenCount),
        _StatTile(label: l10n.adminStatSnapshots, value: stats.ipSnapshotCount),
      ],
    );
  }

  Widget _buildRoles(AppLocalizations l10n) {
    if (_roles.isEmpty) {
      return Center(child: Text(l10n.adminEmpty));
    }

    return ListView.builder(
      itemCount: _roles.length,
      itemBuilder: (context, index) {
        final role = _roles[index];
        return ListTile(
          title: Text(role.name),
          subtitle: Text(
            '${role.userCount} ${l10n.adminRolesMembers} · ${role.permissions.length} ${l10n.adminRolesPermissionCount}',
          ),
          trailing: const Icon(Icons.security),
          onTap: () => _editRolePermissions(role),
        );
      },
    );
  }

  Future<void> _editRolePermissions(AdminRole role) async {
    final l10n = AppLocalizations.of(context);
    final draft = {...role.permissions};

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(role.name, style: Theme.of(context).textTheme.titleLarge),
                  Text(l10n.adminRolesPermissionsHint),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView(
                      shrinkWrap: true,
                      children: _permissionCatalog.map((item) {
                        final checked = draft.contains(item.key);
                        return CheckboxListTile(
                          value: checked,
                          onChanged: (value) {
                            setModalState(() {
                              if (value == true) {
                                draft.add(item.key);
                              } else {
                                draft.remove(item.key);
                              }
                            });
                          },
                          title: Text(item.key, style: Theme.of(context).textTheme.bodySmall),
                        );
                      }).toList(),
                    ),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text(l10n.noteSave),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (saved == true) {
      await _admin.updateRolePermissions(role.id, draft.toList()..sort());
      await _loadTab(1);
    }
  }

  Widget _buildUsers(AppLocalizations l10n) {
    if (_users.isEmpty) {
      return Center(child: Text(l10n.adminEmpty));
    }

    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user.email ?? user.userName ?? user.id),
          subtitle: Text(user.roles.join(', ')),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editRoles(user),
          ),
        );
      },
    );
  }

  Future<void> _editRoles(AdminUser user) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: user.roles.join(', '));
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.adminEditRoles),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.adminRolesHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.actionCancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.noteSave)),
        ],
      ),
    );
    if (ok == true) {
      final roles = controller.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      await _admin.setUserRoles(user.id, roles);
      await _loadTab(2);
    }
    controller.dispose();
  }

  Widget _buildNotes(AppLocalizations l10n) {
    if (_notes.isEmpty) {
      return Center(child: Text(l10n.adminEmpty));
    }

    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return ListTile(
          title: Text(note.address),
          subtitle: Text('${note.ownerEmail ?? ''} · ${note.title ?? ''}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(() => _admin.deleteIpNote(note.id)),
          ),
        );
      },
    );
  }

  Widget _buildLookups(AppLocalizations l10n) {
    if (_lookups.isEmpty) {
      return Center(child: Text(l10n.adminEmpty));
    }

    return ListView.builder(
      itemCount: _lookups.length,
      itemBuilder: (context, index) {
        final item = _lookups[index];
        return ListTile(
          title: Text(item.address),
          subtitle: Text('${item.city ?? ''} · ${item.isp ?? ''}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(() => _admin.deleteIpLookup(item.id)),
          ),
        );
      },
    );
  }

  Widget _buildPush(AppLocalizations l10n) {
    if (_pushDevices.isEmpty) {
      return Center(child: Text(l10n.adminEmpty));
    }

    return ListView.builder(
      itemCount: _pushDevices.length,
      itemBuilder: (context, index) {
        final device = _pushDevices[index];
        final preview = device.deviceToken.length > 12
            ? '${device.deviceToken.substring(0, 12)}…'
            : device.deviceToken;
        return ListTile(
          title: Text(device.platform),
          subtitle: Text(preview),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(() => _admin.deletePushDevice(device.id)),
          ),
        );
      },
    );
  }

  Widget _buildOutbox(AppLocalizations l10n) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.adminFilterPending),
          value: _pendingOnly,
          onChanged: (value) async {
            setState(() => _pendingOnly = value);
            await _loadTab(6);
          },
        ),
        Expanded(
          child: _outbox.isEmpty
              ? Center(child: Text(l10n.adminEmpty))
              : ListView.builder(
                  itemCount: _outbox.length,
                  itemBuilder: (context, index) {
                    final msg = _outbox[index];
                    return ListTile(
                      title: Text(msg.type),
                      subtitle: Text('${msg.occurredOn}\n${msg.error ?? ''}'),
                      isThreeLine: msg.error != null,
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildTickets(AppLocalizations l10n) {
    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.adminTicketsOpenOnly),
          value: _ticketsOpenOnly,
          onChanged: (value) async {
            setState(() => _ticketsOpenOnly = value);
            await _loadTab(7);
          },
        ),
        Expanded(
          child: _tickets.isEmpty
              ? Center(child: Text(l10n.adminEmpty))
              : ListView.builder(
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _tickets[index];
                    final isOpen = ticket.status == 'Open';
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        title: Text('#${ticket.id} · ${ticket.subject}'),
                        subtitle: Text(
                          '${ticket.name} · ${ticket.email}\n${ticket.message}',
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          tooltip: isOpen ? l10n.adminTicketClose : l10n.adminTicketReopen,
                          icon: Icon(isOpen ? Icons.check_circle_outline : Icons.replay),
                          onPressed: () async {
                            await _admin.updateSupportTicketStatus(
                              ticket.id,
                              isOpen ? 1 : 0,
                            );
                            await _loadTab(7);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(label),
        trailing: Text('$value', style: Theme.of(context).textTheme.titleLarge),
      ),
    );
  }
}
