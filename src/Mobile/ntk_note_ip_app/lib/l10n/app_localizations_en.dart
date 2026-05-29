// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'IPNote.ir';

  @override
  String get homeTagline => 'IP notes and network intelligence';

  @override
  String get myIp => 'My IP';

  @override
  String get loading => 'Loading…';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get ipv4 => 'IPv4';

  @override
  String get ipv6 => 'IPv6';

  @override
  String get scope => 'Scope';

  @override
  String get toggleLanguage => 'Switch language';

  @override
  String get toggleTheme => 'Switch theme';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Sign in for dashboard and IP notes';

  @override
  String get loginAction => 'Sign in';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get logout => 'Sign out';

  @override
  String get refresh => 'Refresh';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardSubtitle => 'Timeline of observed IPs (local + server)';

  @override
  String get dashboardSearch => 'Search';

  @override
  String get dashboardTimeline => 'Timeline';

  @override
  String get dashboardEmpty => 'No items found.';

  @override
  String get dashboardCountries => 'Country filter';

  @override
  String get statTotal => 'Total';

  @override
  String get statUniqueIp => 'Unique IPs';

  @override
  String get statCountries => 'Countries';

  @override
  String get statNotes => 'Notes';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String get exportJson => 'Export JSON';

  @override
  String get notesTitle => 'IP notes';

  @override
  String get notesSubtitle => 'Notes attached to IP addresses';

  @override
  String get notesListTitle => 'My notes';

  @override
  String get notesEmpty => 'No notes yet.';

  @override
  String get noteAddress => 'IP address';

  @override
  String get noteTitle => 'Title';

  @override
  String get noteBody => 'Body';

  @override
  String get noteTags => 'Tags (comma-separated)';

  @override
  String get noteAdd => 'Add note';

  @override
  String get noteDelete => 'Delete';

  @override
  String get noteEdit => 'Edit';

  @override
  String get noteSave => 'Save';

  @override
  String get noteUpdateTitle => 'Edit note';

  @override
  String get useMyIp => 'My IP';

  @override
  String get noteThis => 'Note this';

  @override
  String get noteSnapshotReady =>
      'Time, device, and IP details will be attached to this note.';

  @override
  String get openLookup => 'View IP';

  @override
  String get lookupAddress => 'Look up IP';

  @override
  String get localIp => 'Local IP (Wi‑Fi)';

  @override
  String get showQr => 'Show QR';

  @override
  String get openMap => 'Open in OpenStreetMap';

  @override
  String get geoTitle => 'Geolocation';

  @override
  String get country => 'Country';

  @override
  String get region => 'City / region';

  @override
  String get timezone => 'Timezone';

  @override
  String get networkTitle => 'Network & ISP';

  @override
  String get isp => 'ISP';

  @override
  String get asn => 'ASN';

  @override
  String get organization => 'Organization';

  @override
  String get reverseDns => 'Reverse DNS';

  @override
  String get deviceTitle => 'Device';

  @override
  String get recentHistory => 'Recent history';

  @override
  String get historyClear => 'Clear';

  @override
  String get cmdTitle => 'Get IP command';

  @override
  String get cmdTabLinux => 'Linux';

  @override
  String get cmdTabMac => 'macOS';

  @override
  String get cmdTabWindows => 'Windows';

  @override
  String get cmdTabPowershell => 'PowerShell';

  @override
  String get cmdTabMikrotik => 'MikroTik';

  @override
  String get toolsTitle => 'Tools';

  @override
  String get toolsSubtitle => 'Network tools and IP compare';

  @override
  String get toolsHubLookup => 'IP lookup';

  @override
  String get toolsHubLookupDesc => 'Back to home for full IP details';

  @override
  String get toolsCompareTitle => 'Compare two IPs';

  @override
  String get toolsCompareA => 'First IP';

  @override
  String get toolsCompareB => 'Second IP';

  @override
  String get toolsCompareRun => 'Compare';

  @override
  String get compareAddress => 'Address';

  @override
  String get compareGeo => 'Location';

  @override
  String get compareIsp => 'ISP';

  @override
  String get compareAsn => 'ASN';

  @override
  String get compareReverseDns => 'Reverse DNS';

  @override
  String get compareScope => 'Scope';

  @override
  String get biometricLockTitle => 'App locked';

  @override
  String get biometricLockSubtitle =>
      'Confirm with fingerprint or Face ID to continue';

  @override
  String get biometricUnlockAction => 'Unlock';

  @override
  String get biometricUnlockReason => 'Verify your identity to open IPNote.ir';

  @override
  String get biometricUnlockFailed => 'Authentication failed';

  @override
  String get biometricSettingTitle => 'Unlock with biometrics';

  @override
  String get biometricSettingSubtitle =>
      'Show a biometric lock when returning to the app';

  @override
  String get biometricUnavailable =>
      'Biometric authentication is not available on this device';

  @override
  String get backgroundMonitorTitle => 'Background IP monitor';

  @override
  String get backgroundMonitorSubtitle =>
      'Checks your public IP about every 30 minutes and notifies on change';

  @override
  String get notificationPermissionDenied =>
      'Notification permission is required for IP change alerts';

  @override
  String backgroundIpChangedNotification(String address) {
    return 'Your public IP changed to $address';
  }
}
