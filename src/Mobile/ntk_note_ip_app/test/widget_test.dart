import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ntk_note_ip_app/app.dart';
import 'package:ntk_note_ip_app/core/settings/app_settings.dart';
import 'package:ntk_note_ip_app/presentation/providers/app_version_provider.dart';
import 'package:ntk_note_ip_app/presentation/providers/auth_controller.dart';
import 'package:ntk_note_ip_app/presentation/providers/settings_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app renders home title', (tester) async {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          settingsControllerProvider.overrideWith(_TestSettingsController.new),
          authControllerProvider.overrideWith(_TestAuthController.new),
          splashMinimumDurationProvider.overrideWith(
            (ref) => Duration.zero,
          ),
        ],
        child: const IpNoteApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('IPNote.ir'), findsWidgets);
  });
}

class _TestSettingsController extends SettingsController {
  @override
  Future<AppSettings> build() async =>
      AppSettings.defaults.copyWith(localeChosen: true);
}

class _TestAuthController extends AuthController {
  @override
  AuthState build() => const AuthState(loading: false);
}
