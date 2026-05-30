import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/settings/supported_app_locales.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/settings_controller.dart';
import '../splash/app_splash_screen.dart';

class LanguagePickerScreen extends ConsumerStatefulWidget {
  const LanguagePickerScreen({
    required this.onFinished,
    super.key,
  });

  final VoidCallback onFinished;

  @override
  ConsumerState<LanguagePickerScreen> createState() =>
      _LanguagePickerScreenState();
}

class _LanguagePickerScreenState extends ConsumerState<LanguagePickerScreen> {
  Locale? _selected;
  var _submitting = false;

  @override
  void initState() {
    super.initState();
    _selected = resolveBootstrapLocale(
      WidgetsBinding.instance.platformDispatcher.locale,
    );
  }

  Future<void> _continue() async {
    final locale = _selected;
    if (locale == null || _submitting) {
      return;
    }

    setState(() => _submitting = true);
    await ref.read(settingsControllerProvider.notifier).completeLocaleOnboarding(
          locale,
        );
    if (mounted) {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final previewLocale = _selected ?? const Locale('fa');
    final l10n = lookupAppLocalizations(previewLocale);
    final scheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: _textDirectionFor(previewLocale),
      child: Scaffold(
        backgroundColor: AppSplashColors.background,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppSplashColors.background,
                Color(0xFF241B33),
                AppSplashColors.background,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        'assets/brand/app_icon.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.languagePickerTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.languagePickerSubtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.72),
                        ),
                  ),
                  const SizedBox(height: 28),
                  Expanded(
                    child: ListView.separated(
                      itemCount: supportedAppLocales.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final option = supportedAppLocales[index];
                        final selected =
                            _selected?.languageCode == option.locale.languageCode;

                        return Material(
                          color: selected
                              ? scheme.primaryContainer.withValues(alpha: 0.55)
                              : scheme.surfaceContainerHighest.withValues(
                                  alpha: 0.35,
                                ),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: _submitting
                                ? null
                                : () => setState(() => _selected = option.locale),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: selected
                                        ? scheme.primary
                                        : scheme.onSurface.withValues(
                                            alpha: 0.55,
                                          ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      option.nativeLabel,
                                      textDirection: option.textDirection,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: selected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _selected == null || _submitting ? null : _continue,
                    child: _submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.languagePickerContinue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextDirection _textDirectionFor(Locale locale) {
    return supportedAppLocales
            .where((e) => e.locale.languageCode == locale.languageCode)
            .map((e) => e.textDirection)
            .firstOrNull ??
        TextDirection.ltr;
  }
}
