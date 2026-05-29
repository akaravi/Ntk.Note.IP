import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fa, this message translates to:
  /// **'IPNote.ir'**
  String get appTitle;

  /// No description provided for @homeTagline.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت و مدیریت اطلاعات IP'**
  String get homeTagline;

  /// No description provided for @myIp.
  ///
  /// In fa, this message translates to:
  /// **'IP من'**
  String get myIp;

  /// No description provided for @loading.
  ///
  /// In fa, this message translates to:
  /// **'در حال بارگذاری…'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In fa, this message translates to:
  /// **'خطا'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In fa, this message translates to:
  /// **'تلاش مجدد'**
  String get retry;

  /// No description provided for @copy.
  ///
  /// In fa, this message translates to:
  /// **'کپی'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In fa, this message translates to:
  /// **'کپی شد'**
  String get copied;

  /// No description provided for @ipv4.
  ///
  /// In fa, this message translates to:
  /// **'IPv4'**
  String get ipv4;

  /// No description provided for @ipv6.
  ///
  /// In fa, this message translates to:
  /// **'IPv6'**
  String get ipv6;

  /// No description provided for @scope.
  ///
  /// In fa, this message translates to:
  /// **'محدوده'**
  String get scope;

  /// No description provided for @toggleLanguage.
  ///
  /// In fa, this message translates to:
  /// **'تغییر زبان'**
  String get toggleLanguage;

  /// No description provided for @toggleTheme.
  ///
  /// In fa, this message translates to:
  /// **'تغییر تم'**
  String get toggleTheme;

  /// No description provided for @loginTitle.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'برای داشبورد و یادداشت‌های IP وارد شوید'**
  String get loginSubtitle;

  /// No description provided for @loginAction.
  ///
  /// In fa, this message translates to:
  /// **'ورود'**
  String get loginAction;

  /// No description provided for @email.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور'**
  String get password;

  /// No description provided for @fieldRequired.
  ///
  /// In fa, this message translates to:
  /// **'این فیلد الزامی است'**
  String get fieldRequired;

  /// No description provided for @actionCancel.
  ///
  /// In fa, this message translates to:
  /// **'انصراف'**
  String get actionCancel;

  /// No description provided for @logout.
  ///
  /// In fa, this message translates to:
  /// **'خروج'**
  String get logout;

  /// No description provided for @refresh.
  ///
  /// In fa, this message translates to:
  /// **'بروزرسانی'**
  String get refresh;

  /// No description provided for @dashboardTitle.
  ///
  /// In fa, this message translates to:
  /// **'داشبورد'**
  String get dashboardTitle;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'خط زمانی IPهای مشاهده‌شده (محلی + سرور)'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardSearch.
  ///
  /// In fa, this message translates to:
  /// **'جستجو'**
  String get dashboardSearch;

  /// No description provided for @dashboardTimeline.
  ///
  /// In fa, this message translates to:
  /// **'خط زمانی'**
  String get dashboardTimeline;

  /// No description provided for @dashboardEmpty.
  ///
  /// In fa, this message translates to:
  /// **'موردی یافت نشد.'**
  String get dashboardEmpty;

  /// No description provided for @dashboardCountries.
  ///
  /// In fa, this message translates to:
  /// **'فیلتر کشور'**
  String get dashboardCountries;

  /// No description provided for @statTotal.
  ///
  /// In fa, this message translates to:
  /// **'کل'**
  String get statTotal;

  /// No description provided for @statUniqueIp.
  ///
  /// In fa, this message translates to:
  /// **'IP یکتا'**
  String get statUniqueIp;

  /// No description provided for @statCountries.
  ///
  /// In fa, this message translates to:
  /// **'کشور'**
  String get statCountries;

  /// No description provided for @statNotes.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت'**
  String get statNotes;

  /// No description provided for @exportCsv.
  ///
  /// In fa, this message translates to:
  /// **'خروجی CSV'**
  String get exportCsv;

  /// No description provided for @exportJson.
  ///
  /// In fa, this message translates to:
  /// **'خروجی JSON'**
  String get exportJson;

  /// No description provided for @notesTitle.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت IP'**
  String get notesTitle;

  /// No description provided for @notesSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت روی آدرس‌های IP'**
  String get notesSubtitle;

  /// No description provided for @notesListTitle.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت‌های من'**
  String get notesListTitle;

  /// No description provided for @notesEmpty.
  ///
  /// In fa, this message translates to:
  /// **'یادداشتی ثبت نشده است.'**
  String get notesEmpty;

  /// No description provided for @noteAddress.
  ///
  /// In fa, this message translates to:
  /// **'آدرس IP'**
  String get noteAddress;

  /// No description provided for @noteTitle.
  ///
  /// In fa, this message translates to:
  /// **'عنوان'**
  String get noteTitle;

  /// No description provided for @noteBody.
  ///
  /// In fa, this message translates to:
  /// **'متن'**
  String get noteBody;

  /// No description provided for @noteTags.
  ///
  /// In fa, this message translates to:
  /// **'برچسب‌ها (با کاما)'**
  String get noteTags;

  /// No description provided for @noteAdd.
  ///
  /// In fa, this message translates to:
  /// **'افزودن یادداشت'**
  String get noteAdd;

  /// No description provided for @noteDelete.
  ///
  /// In fa, this message translates to:
  /// **'حذف'**
  String get noteDelete;

  /// No description provided for @noteEdit.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش'**
  String get noteEdit;

  /// No description provided for @noteSave.
  ///
  /// In fa, this message translates to:
  /// **'ذخیره'**
  String get noteSave;

  /// No description provided for @noteUpdateTitle.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش یادداشت'**
  String get noteUpdateTitle;

  /// No description provided for @useMyIp.
  ///
  /// In fa, this message translates to:
  /// **'IP من'**
  String get useMyIp;

  /// No description provided for @noteThis.
  ///
  /// In fa, this message translates to:
  /// **'یاداشت کن'**
  String get noteThis;

  /// No description provided for @noteSnapshotReady.
  ///
  /// In fa, this message translates to:
  /// **'زمان، دستگاه و جزئیات IP برای این یادداشت ضمیمه می‌شود.'**
  String get noteSnapshotReady;

  /// No description provided for @openLookup.
  ///
  /// In fa, this message translates to:
  /// **'مشاهده IP'**
  String get openLookup;

  /// No description provided for @lookupAddress.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی IP'**
  String get lookupAddress;

  /// No description provided for @localIp.
  ///
  /// In fa, this message translates to:
  /// **'IP محلی (Wi‑Fi)'**
  String get localIp;

  /// No description provided for @showQr.
  ///
  /// In fa, this message translates to:
  /// **'نمایش QR'**
  String get showQr;

  /// No description provided for @openMap.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن در OpenStreetMap'**
  String get openMap;

  /// No description provided for @geoTitle.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت جغرافیایی'**
  String get geoTitle;

  /// No description provided for @country.
  ///
  /// In fa, this message translates to:
  /// **'کشور'**
  String get country;

  /// No description provided for @region.
  ///
  /// In fa, this message translates to:
  /// **'شهر / منطقه'**
  String get region;

  /// No description provided for @timezone.
  ///
  /// In fa, this message translates to:
  /// **'منطقهٔ زمانی'**
  String get timezone;

  /// No description provided for @networkTitle.
  ///
  /// In fa, this message translates to:
  /// **'شبکه و ISP'**
  String get networkTitle;

  /// No description provided for @isp.
  ///
  /// In fa, this message translates to:
  /// **'ISP'**
  String get isp;

  /// No description provided for @asn.
  ///
  /// In fa, this message translates to:
  /// **'ASN'**
  String get asn;

  /// No description provided for @organization.
  ///
  /// In fa, this message translates to:
  /// **'سازمان'**
  String get organization;

  /// No description provided for @reverseDns.
  ///
  /// In fa, this message translates to:
  /// **'Reverse DNS'**
  String get reverseDns;

  /// No description provided for @deviceTitle.
  ///
  /// In fa, this message translates to:
  /// **'دستگاه'**
  String get deviceTitle;

  /// No description provided for @recentHistory.
  ///
  /// In fa, this message translates to:
  /// **'تاریخچهٔ اخیر'**
  String get recentHistory;

  /// No description provided for @historyClear.
  ///
  /// In fa, this message translates to:
  /// **'پاک کردن'**
  String get historyClear;

  /// No description provided for @cmdTitle.
  ///
  /// In fa, this message translates to:
  /// **'دستور دریافت IP'**
  String get cmdTitle;

  /// No description provided for @cmdTabLinux.
  ///
  /// In fa, this message translates to:
  /// **'Linux'**
  String get cmdTabLinux;

  /// No description provided for @cmdTabMac.
  ///
  /// In fa, this message translates to:
  /// **'macOS'**
  String get cmdTabMac;

  /// No description provided for @cmdTabWindows.
  ///
  /// In fa, this message translates to:
  /// **'Windows'**
  String get cmdTabWindows;

  /// No description provided for @cmdTabPowershell.
  ///
  /// In fa, this message translates to:
  /// **'PowerShell'**
  String get cmdTabPowershell;

  /// No description provided for @cmdTabMikrotik.
  ///
  /// In fa, this message translates to:
  /// **'MikroTik'**
  String get cmdTabMikrotik;

  /// No description provided for @toolsTitle.
  ///
  /// In fa, this message translates to:
  /// **'ابزارها'**
  String get toolsTitle;

  /// No description provided for @toolsSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'ابزارهای شبکه و مقایسه IP'**
  String get toolsSubtitle;

  /// No description provided for @toolsHubLookup.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی IP'**
  String get toolsHubLookup;

  /// No description provided for @toolsHubLookupDesc.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به صفحهٔ اصلی برای جزئیات IP'**
  String get toolsHubLookupDesc;

  /// No description provided for @toolsCompareTitle.
  ///
  /// In fa, this message translates to:
  /// **'مقایسهٔ دو IP'**
  String get toolsCompareTitle;

  /// No description provided for @toolsCompareA.
  ///
  /// In fa, this message translates to:
  /// **'IP اول'**
  String get toolsCompareA;

  /// No description provided for @toolsCompareB.
  ///
  /// In fa, this message translates to:
  /// **'IP دوم'**
  String get toolsCompareB;

  /// No description provided for @toolsCompareRun.
  ///
  /// In fa, this message translates to:
  /// **'مقایسه'**
  String get toolsCompareRun;

  /// No description provided for @compareAddress.
  ///
  /// In fa, this message translates to:
  /// **'آدرس'**
  String get compareAddress;

  /// No description provided for @compareGeo.
  ///
  /// In fa, this message translates to:
  /// **'موقعیت'**
  String get compareGeo;

  /// No description provided for @compareIsp.
  ///
  /// In fa, this message translates to:
  /// **'ISP'**
  String get compareIsp;

  /// No description provided for @compareAsn.
  ///
  /// In fa, this message translates to:
  /// **'ASN'**
  String get compareAsn;

  /// No description provided for @compareReverseDns.
  ///
  /// In fa, this message translates to:
  /// **'Reverse DNS'**
  String get compareReverseDns;

  /// No description provided for @compareScope.
  ///
  /// In fa, this message translates to:
  /// **'محدوده'**
  String get compareScope;

  /// No description provided for @biometricLockTitle.
  ///
  /// In fa, this message translates to:
  /// **'اپ قفل است'**
  String get biometricLockTitle;

  /// No description provided for @biometricLockSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'برای ادامه، اثر انگشت یا Face ID را تأیید کنید'**
  String get biometricLockSubtitle;

  /// No description provided for @biometricUnlockAction.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن قفل'**
  String get biometricUnlockAction;

  /// No description provided for @biometricUnlockReason.
  ///
  /// In fa, this message translates to:
  /// **'تأیید هویت برای باز کردن IPNote.ir'**
  String get biometricUnlockReason;

  /// No description provided for @biometricUnlockFailed.
  ///
  /// In fa, this message translates to:
  /// **'احراز هویت ناموفق بود'**
  String get biometricUnlockFailed;

  /// No description provided for @biometricSettingTitle.
  ///
  /// In fa, this message translates to:
  /// **'باز کردن با اثر انگشت'**
  String get biometricSettingTitle;

  /// No description provided for @biometricSettingSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'هنگام بازگشت به اپ، قفل بیومتریک نمایش داده می‌شود'**
  String get biometricSettingSubtitle;

  /// No description provided for @biometricUnavailable.
  ///
  /// In fa, this message translates to:
  /// **'احراز هویت بیومتریک روی این دستگاه در دسترس نیست'**
  String get biometricUnavailable;

  /// No description provided for @backgroundMonitorTitle.
  ///
  /// In fa, this message translates to:
  /// **'مانیتور تغییر IP در پس‌زمینه'**
  String get backgroundMonitorTitle;

  /// No description provided for @backgroundMonitorSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'هر ۳۰ دقیقه IP عمومی را بررسی می‌کند و در صورت تغییر اعلان می‌دهد'**
  String get backgroundMonitorSubtitle;

  /// No description provided for @notificationPermissionDenied.
  ///
  /// In fa, this message translates to:
  /// **'برای اعلان تغییر IP، مجوز اعلان لازم است'**
  String get notificationPermissionDenied;

  /// No description provided for @backgroundIpChangedNotification.
  ///
  /// In fa, this message translates to:
  /// **'IP عمومی شما به {address} تغییر کرد'**
  String backgroundIpChangedNotification(String address);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
