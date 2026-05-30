import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../data/datasources/contact_remote_datasource.dart';
import '../../providers/app_providers.dart';
import '../../widgets/app_scaffold.dart';
import '../../widgets/ltr_technical_text.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  var _submitting = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
      _success = null;
    });

    final remote = ContactRemoteDataSource(ref.read(baseApiClientProvider).dio);
    final result = await remote.submit(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    setState(() {
      _submitting = false;
      if (result.isSuccess) {
        _success = result.data!.emailSent
            ? l10n.contactSuccess
            : l10n.contactSuccessNoEmail;
        _subjectController.clear();
        _messageController.clear();
      } else {
        _error = result.errorMessage ?? l10n.contactError;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return AppScaffold(
      title: l10n.contactTitle,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.contactSubtitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.contactName,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                LtrTextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: l10n.contactSubject,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _messageController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: l10n.contactMessage,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.fieldRequired;
                    }

                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: TextStyle(color: scheme.error)),
                ],
                if (_success != null) ...[
                  const SizedBox(height: 12),
                  Text(_success!, style: TextStyle(color: scheme.primary)),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.contactSubmit),
                ),
                const SizedBox(height: 12),
                TextButton(onPressed: () => context.go('/about'), child: Text(l10n.aboutTitle)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
