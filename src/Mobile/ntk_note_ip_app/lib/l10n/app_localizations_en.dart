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
  String get rememberMe => 'Remember me (1 month)';

  @override
  String get contactTitle => 'Contact us';

  @override
  String get contactSubtitle =>
      'Send us a message — our support team will respond as soon as possible.';

  @override
  String get contactName => 'Name';

  @override
  String get contactSubject => 'Subject';

  @override
  String get contactMessage => 'Message';

  @override
  String get contactSubmit => 'Send';

  @override
  String get contactSuccess =>
      'Your message was saved and a notification email was sent.';

  @override
  String get contactSuccessNoEmail =>
      'Your message was saved. Email could not be sent; the ticket is stored in admin.';

  @override
  String get contactError => 'Submission failed. Please try again.';

  @override
  String get footerContact => 'Contact us';

  @override
  String get adminTicketsTab => 'Tickets';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerSubtitle => 'Create an account for dashboard and IP notes';

  @override
  String get registerAction => 'Register';

  @override
  String get registerSuccess => 'Registration successful. Please sign in.';

  @override
  String get registerFailed => 'Registration failed. Please try again.';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get hasAccount => 'Already have an account?';

  @override
  String get emailInvalid => 'Enter a valid email address.';

  @override
  String passwordMinLength(int min) {
    return 'Password must be at least $min characters.';
  }

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

  @override
  String get languagePickerTitle => 'Choose your language';

  @override
  String get languagePickerSubtitle =>
      'Select your preferred interface language';

  @override
  String get languagePickerContinue => 'Continue';

  @override
  String splashVersion(String version) {
    return 'Version $version';
  }

  @override
  String get plainText => 'Copy plain IP';

  @override
  String get plainCopied => 'Copied';

  @override
  String get historyRemove => 'Remove';

  @override
  String get historySync => 'Syncing with account…';

  @override
  String get codeTitle => 'Code samples';

  @override
  String get codeHint => 'Integrate in your app';

  @override
  String get codeCopy => 'Copy code';

  @override
  String get codeTabCsharp => 'C#';

  @override
  String get codeTabJavascript => 'JavaScript';

  @override
  String get codeTabPython => 'Python';

  @override
  String get codeTabBash => 'Bash';

  @override
  String get deviceBrowser => 'Browser';

  @override
  String get deviceOs => 'OS';

  @override
  String get deviceType => 'Device type';

  @override
  String get deviceLanguage => 'Language';

  @override
  String get toolsHubWhois => 'WHOIS & IP security';

  @override
  String get toolsHubWhoisDesc => 'WHOIS, blacklist, VPN/proxy flags';

  @override
  String get toolsHubDns => 'DNS lookup';

  @override
  String get toolsHubDnsDesc => 'DNS records for a domain';

  @override
  String get toolsHubPropagation => 'DNS propagation';

  @override
  String get toolsHubPropagationDesc => 'Compare public resolvers';

  @override
  String get toolsHubPort => 'Port & SSL';

  @override
  String get toolsHubPortDesc => 'Open port check and SSL certificate';

  @override
  String get toolsHubWhoisDomain => 'Domain WHOIS';

  @override
  String get toolsHubWhoisDomainDesc => 'Domain registration info';

  @override
  String get toolsWhois => 'WHOIS / RDAP';

  @override
  String get toolsWhoisRun => 'Run WHOIS';

  @override
  String get toolsBlacklist => 'DNSBL blacklist';

  @override
  String get toolsPrivacy => 'VPN / proxy / mobile';

  @override
  String get toolsListed => 'Listed';

  @override
  String get toolsClean => 'Clean';

  @override
  String get toolsCidr => 'CIDR';

  @override
  String get toolsSubnet => 'Calculate subnet';

  @override
  String get toolsWhoisDomain => 'Domain WHOIS';

  @override
  String get toolsPort => 'Check port';

  @override
  String get toolsSsl => 'SSL certificate';

  @override
  String get toolsPortOpen => 'Open';

  @override
  String get toolsPortClosed => 'Closed';

  @override
  String get dnsDomain => 'Domain name';

  @override
  String get dnsResolve => 'Resolve DNS';

  @override
  String get dnsType => 'Record type';

  @override
  String get dnsPropagationCheck => 'Check propagation';

  @override
  String get dnsMatches => 'Matches';

  @override
  String get dnsDiffers => 'Differs';

  @override
  String get domainToolsTitle => 'Domain checks';

  @override
  String get domainToolsDesc =>
      'WHOIS, DNS, propagation, port and SSL in one place';

  @override
  String get domainToolsRunAll => 'Run all domain checks';

  @override
  String get domainTabWhois => 'WHOIS';

  @override
  String get domainTabDns => 'DNS';

  @override
  String get domainTabPropagation => 'Propagation';

  @override
  String get domainTabPortSsl => 'Port / SSL';

  @override
  String get domainTabEmpty => 'Press run or enter a domain first.';

  @override
  String get introTitle => 'Welcome';

  @override
  String get introBody =>
      'IPNote.ir — IP lookup, notes, and network tools for web and mobile.';

  @override
  String get footerChangelog => 'Changelog';

  @override
  String get footerStatus => 'Service status';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSubtitle => 'IPNote.ir — an NTK product';

  @override
  String get aboutProductTitle => 'What is IPNote.ir?';

  @override
  String get aboutProductBody =>
      'View your public IP, network details, notes, and DNS/WHOIS tools.';

  @override
  String get aboutFeatureLookup => 'IP lookup, geo, ASN, map';

  @override
  String get aboutFeatureNotes => 'Personal IP notes';

  @override
  String get aboutFeatureTools => 'DNS, WHOIS, port, SSL, subnet';

  @override
  String get aboutFeatureMobile => 'Mobile app with light/dark theme';

  @override
  String get aboutNtkTitle => 'NTK';

  @override
  String get aboutNtkBody =>
      'NTK has been active in IT, software, and hosting since 2008.';

  @override
  String get aboutAuthorTitle => 'Alireza Karavi';

  @override
  String get aboutAuthorBody =>
      'Full-stack developer focused on networking and security.';

  @override
  String get aboutAuthorSkill1 => '.NET, Angular, Flutter';

  @override
  String get aboutAuthorSkill2 => 'MikroTik, VoIP, monitoring';

  @override
  String get aboutAuthorSkill3 => 'Product leadership at NTK';

  @override
  String get aboutEcosystemTitle => 'Related projects';

  @override
  String get aboutEcosystemHint => 'Sibling brands and services';

  @override
  String get aboutBack => 'Back to lookup';

  @override
  String get copyrightTitle => 'Copyright';

  @override
  String get copyrightSubtitle => 'Legal information for IPNote.ir';

  @override
  String get copyrightOwnershipTitle => 'Ownership';

  @override
  String get copyrightOwnershipBody =>
      'IPNote.ir is owned by NTK / Alireza Karavi.';

  @override
  String get copyrightLicenseTitle => 'License';

  @override
  String get copyrightLicenseBody =>
      'Personal use is allowed; abuse and API overload are prohibited.';

  @override
  String get copyrightTrademarksTitle => 'Trademarks';

  @override
  String get copyrightTrademarksBody =>
      'IPNote.ir and NTK are related trademarks.';

  @override
  String get copyrightThirdPartyTitle => 'Third-party services';

  @override
  String get copyrightThirdPartyBody =>
      'Data is fetched from geo/DNS/WHOIS providers.';

  @override
  String get copyrightPrivacyTitle => 'Privacy';

  @override
  String get copyrightPrivacyBody =>
      'Notes are visible only to the authenticated owner.';

  @override
  String get copyrightContactTitle => 'Legal contact';

  @override
  String get copyrightContactBody =>
      'Contact support for commercial licensing or DMCA.';

  @override
  String get copyrightBack => 'Back';

  @override
  String get adminTitle => 'Admin panel';

  @override
  String get adminAccessDenied => 'Administrator access required.';

  @override
  String get adminBackToApp => 'Back';

  @override
  String get adminEmpty => 'Nothing to show.';

  @override
  String get adminConfirmDelete => 'Delete this item?';

  @override
  String get adminEditRoles => 'Edit roles';

  @override
  String get adminRolesHint => 'Administrator, …';

  @override
  String get adminRolesMembers => 'members';

  @override
  String get adminRolesPermissionCount => 'permissions';

  @override
  String get adminRolesPermissionsHint => 'Choose permissions for this role.';

  @override
  String get adminFilterPending => 'Pending only';

  @override
  String get adminNavDashboard => 'Dashboard';

  @override
  String get adminNavRoles => 'Roles';

  @override
  String get adminNavUsers => 'Users';

  @override
  String get adminNavNotes => 'Notes';

  @override
  String get adminNavLookups => 'Lookups';

  @override
  String get adminNavPush => 'Push';

  @override
  String get adminNavOutbox => 'Outbox';

  @override
  String get adminStatUsers => 'Users';

  @override
  String get adminStatRoles => 'Roles';

  @override
  String get adminStatNotes => 'Notes';

  @override
  String get adminStatLookups => 'Lookups';

  @override
  String get adminStatPush => 'Push devices';

  @override
  String get adminStatOutbox => 'Pending outbox';

  @override
  String get adminStatTicketsOpen => 'Open tickets';

  @override
  String get adminStatSnapshots => 'Snapshots';

  @override
  String get adminTicketsOpenOnly => 'Open tickets only';

  @override
  String get adminTicketClose => 'Close ticket';

  @override
  String get adminTicketReopen => 'Reopen ticket';
}
