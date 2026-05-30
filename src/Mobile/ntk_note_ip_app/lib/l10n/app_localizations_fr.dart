// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'IPNote.ir';

  @override
  String get homeTagline => 'Notes IP et intelligence réseau';

  @override
  String get myIp => 'Mon IP';

  @override
  String get loading => 'Chargement…';

  @override
  String get error => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Copié';

  @override
  String get ipv4 => 'IPv4';

  @override
  String get ipv6 => 'IPv6';

  @override
  String get scope => 'Portée';

  @override
  String get toggleLanguage => 'Changer de langue';

  @override
  String get toggleTheme => 'Changer de thème';

  @override
  String get loginTitle => 'Connexion';

  @override
  String get loginSubtitle =>
      'Connectez-vous pour le tableau de bord et les notes IP';

  @override
  String get loginAction => 'Se connecter';

  @override
  String get rememberMe => 'Se souvenir de moi (1 mois)';

  @override
  String get contactTitle => 'Contactez-nous';

  @override
  String get contactSubtitle =>
      'Envoyez-nous un message — notre équipe vous répondra dès que possible.';

  @override
  String get contactName => 'Nom';

  @override
  String get contactSubject => 'Sujet';

  @override
  String get contactMessage => 'Message';

  @override
  String get contactSubmit => 'Envoyer';

  @override
  String get contactSuccess =>
      'Votre message a été enregistré et un e-mail de notification a été envoyé.';

  @override
  String get contactSuccessNoEmail =>
      'Votre message a été enregistré. L\'e-mail n\'a pas pu être envoyé ; le ticket est dans l\'admin.';

  @override
  String get contactError => 'Échec de l\'envoi. Veuillez réessayer.';

  @override
  String get footerContact => 'Contact';

  @override
  String get adminTicketsTab => 'Tickets';

  @override
  String get registerTitle => 'Inscription';

  @override
  String get registerSubtitle =>
      'Créez un compte pour le tableau de bord et les notes IP';

  @override
  String get registerAction => 'S\'inscrire';

  @override
  String get registerSuccess => 'Inscription réussie. Veuillez vous connecter.';

  @override
  String get registerFailed => 'Échec de l\'inscription. Réessayez.';

  @override
  String get noAccount => 'Pas de compte ?';

  @override
  String get hasAccount => 'Vous avez déjà un compte ?';

  @override
  String get emailInvalid => 'Saisissez une adresse e-mail valide.';

  @override
  String passwordMinLength(int min) {
    return 'Le mot de passe doit contenir au moins $min caractères.';
  }

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get actionCancel => 'Annuler';

  @override
  String get logout => 'Déconnexion';

  @override
  String get refresh => 'Actualiser';

  @override
  String get dashboardTitle => 'Tableau de bord';

  @override
  String get dashboardSubtitle =>
      'Chronologie des IP observées (local + serveur)';

  @override
  String get dashboardSearch => 'Rechercher';

  @override
  String get dashboardTimeline => 'Chronologie';

  @override
  String get dashboardEmpty => 'Aucun élément trouvé.';

  @override
  String get dashboardCountries => 'Filtre par pays';

  @override
  String get statTotal => 'Total';

  @override
  String get statUniqueIp => 'IP uniques';

  @override
  String get statCountries => 'Pays';

  @override
  String get statNotes => 'Notes';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String get exportJson => 'Exporter JSON';

  @override
  String get notesTitle => 'Notes IP';

  @override
  String get notesSubtitle => 'Notes associées aux adresses IP';

  @override
  String get notesListTitle => 'Mes notes';

  @override
  String get notesEmpty => 'Aucune note pour le moment.';

  @override
  String get noteAddress => 'Adresse IP';

  @override
  String get noteTitle => 'Titre';

  @override
  String get noteBody => 'Contenu';

  @override
  String get noteTags => 'Tags (séparés par des virgules)';

  @override
  String get noteAdd => 'Ajouter une note';

  @override
  String get noteDelete => 'Supprimer';

  @override
  String get noteEdit => 'Modifier';

  @override
  String get noteSave => 'Enregistrer';

  @override
  String get noteUpdateTitle => 'Modifier la note';

  @override
  String get useMyIp => 'Mon IP';

  @override
  String get noteThis => 'Noter';

  @override
  String get noteSnapshotReady =>
      'L\'heure, l\'appareil et les détails IP seront joints à cette note.';

  @override
  String get openLookup => 'Voir l\'IP';

  @override
  String get lookupAddress => 'Rechercher une IP';

  @override
  String get localIp => 'IP locale (Wi‑Fi)';

  @override
  String get showQr => 'Afficher le QR';

  @override
  String get openMap => 'Ouvrir dans OpenStreetMap';

  @override
  String get geoTitle => 'Géolocalisation';

  @override
  String get country => 'Pays';

  @override
  String get region => 'Ville / région';

  @override
  String get timezone => 'Fuseau horaire';

  @override
  String get networkTitle => 'Réseau et FAI';

  @override
  String get isp => 'FAI';

  @override
  String get asn => 'ASN';

  @override
  String get organization => 'Organisation';

  @override
  String get reverseDns => 'DNS inverse';

  @override
  String get deviceTitle => 'Appareil';

  @override
  String get recentHistory => 'Historique récent';

  @override
  String get historyClear => 'Effacer';

  @override
  String get cmdTitle => 'Commande pour obtenir l\'IP';

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
  String get toolsTitle => 'Outils';

  @override
  String get toolsSubtitle => 'Outils réseau et comparaison d\'IP';

  @override
  String get toolsHubLookup => 'Recherche IP';

  @override
  String get toolsHubLookupDesc =>
      'Retour à l\'accueil pour les détails IP complets';

  @override
  String get toolsCompareTitle => 'Comparer deux IP';

  @override
  String get toolsCompareA => 'Première IP';

  @override
  String get toolsCompareB => 'Deuxième IP';

  @override
  String get toolsCompareRun => 'Comparer';

  @override
  String get compareAddress => 'Adresse';

  @override
  String get compareGeo => 'Emplacement';

  @override
  String get compareIsp => 'FAI';

  @override
  String get compareAsn => 'ASN';

  @override
  String get compareReverseDns => 'DNS inverse';

  @override
  String get compareScope => 'Portée';

  @override
  String get biometricLockTitle => 'Application verrouillée';

  @override
  String get biometricLockSubtitle =>
      'Confirmez avec empreinte ou Face ID pour continuer';

  @override
  String get biometricUnlockAction => 'Déverrouiller';

  @override
  String get biometricUnlockReason =>
      'Vérifiez votre identité pour ouvrir IPNote.ir';

  @override
  String get biometricUnlockFailed => 'Échec de l\'authentification';

  @override
  String get biometricSettingTitle => 'Déverrouillage biométrique';

  @override
  String get biometricSettingSubtitle =>
      'Afficher un verrou biométrique au retour dans l\'app';

  @override
  String get biometricUnavailable =>
      'L\'authentification biométrique n\'est pas disponible sur cet appareil';

  @override
  String get backgroundMonitorTitle => 'Surveillance IP en arrière-plan';

  @override
  String get backgroundMonitorSubtitle =>
      'Vérifie votre IP publique environ toutes les 30 minutes et notifie en cas de changement';

  @override
  String get notificationPermissionDenied =>
      'L\'autorisation de notification est requise pour les alertes de changement d\'IP';

  @override
  String backgroundIpChangedNotification(String address) {
    return 'Votre IP publique a changé pour $address';
  }

  @override
  String get languagePickerTitle => 'Choisissez votre langue';

  @override
  String get languagePickerSubtitle => 'Sélectionnez la langue de l\'interface';

  @override
  String get languagePickerContinue => 'Continuer';

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
  String get domainToolsDesc => 'WHOIS, DNS, propagation, port and SSL';

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
  String get adminStatTicketsOpen => 'Tickets ouverts';

  @override
  String get adminStatSnapshots => 'Snapshots';

  @override
  String get adminTicketsOpenOnly => 'Ouverts seulement';

  @override
  String get adminTicketClose => 'Fermer';

  @override
  String get adminTicketReopen => 'Rouvrir';
}
