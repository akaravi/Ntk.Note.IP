import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/splash/native_splash_binding.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/app_version_provider.dart';

abstract final class AppSplashColors {
  static const background = Color(0xFF1A1625);
  static const accent = Color(0xFF6D28D9);
}

class AppSplashScreen extends ConsumerStatefulWidget {
  const AppSplashScreen({
    required this.ready,
    required this.onFinished,
    super.key,
  });

  final bool ready;
  final VoidCallback onFinished;

  @override
  ConsumerState<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends ConsumerState<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _contentOpacity;

  Timer? _minimumTimer;
  var _minimumElapsed = false;
  var _nativeSplashRemoved = false;
  var _finished = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.15, 1, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_nativeSplashRemoved) {
        removeNativeSplash();
        _nativeSplashRemoved = true;
      }
      unawaited(_controller.forward());
    });

    final minimum = ref.read(splashMinimumDurationProvider);
    _minimumTimer = Timer(minimum, () {
      if (!mounted) {
        return;
      }
      setState(() => _minimumElapsed = true);
      _tryFinish();
    });
  }

  @override
  void didUpdateWidget(covariant AppSplashScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.ready && !oldWidget.ready) {
      _tryFinish();
    }
  }

  void _tryFinish() {
    if (_finished || !widget.ready || !_minimumElapsed) {
      return;
    }

    _finished = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onFinished();
      }
    });
  }

  @override
  void dispose() {
    _minimumTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final versionAsync = ref.watch(appVersionProvider);
    final scheme = Theme.of(context).colorScheme;
    final versionLabel = versionAsync.maybeWhen(
      data: (info) => '${info.version} (${info.buildNumber})',
      orElse: () => '…',
    );

    return Scaffold(
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
          child: FadeTransition(
            opacity: _contentOpacity,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _logoScale,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: AppSplashColors.accent.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 32,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(28),
                            child: Image.asset(
                              'assets/brand/app_icon.png',
                              width: 112,
                              height: 112,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: scheme.onSurface,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          l10n.homeTagline,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: scheme.onSurface.withValues(alpha: 0.72),
                              ),
                        ),
                      ),
                      if (!widget.ready) ...[
                        const SizedBox(height: 28),
                        SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: scheme.primary.withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 20,
                  child: Text(
                    l10n.splashVersion(versionLabel),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurface.withValues(alpha: 0.58),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
