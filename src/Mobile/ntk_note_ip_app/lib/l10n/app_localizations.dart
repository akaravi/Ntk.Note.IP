import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('fa'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fa, this message translates to:
  /// **'IP Note'**
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

  /// No description provided for @rememberMe.
  ///
  /// In fa, this message translates to:
  /// **'مرا به خاطر بسپار (۱ ماه)'**
  String get rememberMe;

  /// No description provided for @contactTitle.
  ///
  /// In fa, this message translates to:
  /// **'تماس با ما'**
  String get contactTitle;

  /// No description provided for @contactSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'پیام خود را بفرستید؛ تیم پشتیبانی در اسرع وقت پاسخ می‌دهد.'**
  String get contactSubtitle;

  /// No description provided for @contactName.
  ///
  /// In fa, this message translates to:
  /// **'نام'**
  String get contactName;

  /// No description provided for @contactSubject.
  ///
  /// In fa, this message translates to:
  /// **'موضوع'**
  String get contactSubject;

  /// No description provided for @contactMessage.
  ///
  /// In fa, this message translates to:
  /// **'پیام'**
  String get contactMessage;

  /// No description provided for @contactSubmit.
  ///
  /// In fa, this message translates to:
  /// **'ارسال'**
  String get contactSubmit;

  /// No description provided for @contactSuccess.
  ///
  /// In fa, this message translates to:
  /// **'پیام شما ثبت شد و ایمیل اطلاع‌رسانی ارسال گردید.'**
  String get contactSuccess;

  /// No description provided for @contactSuccessNoEmail.
  ///
  /// In fa, this message translates to:
  /// **'پیام شما ثبت شد. ارسال ایمیل ممکن نبود؛ تیکت در پنل مدیریت ذخیره شده است.'**
  String get contactSuccessNoEmail;

  /// No description provided for @contactError.
  ///
  /// In fa, this message translates to:
  /// **'ارسال ناموفق بود. لطفاً دوباره تلاش کنید.'**
  String get contactError;

  /// No description provided for @footerContact.
  ///
  /// In fa, this message translates to:
  /// **'تماس با ما'**
  String get footerContact;

  /// No description provided for @adminTicketsTab.
  ///
  /// In fa, this message translates to:
  /// **'تیکت‌ها'**
  String get adminTicketsTab;

  /// No description provided for @registerTitle.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'حساب جدید برای داشبورد و یادداشت IP'**
  String get registerSubtitle;

  /// No description provided for @registerAction.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام'**
  String get registerAction;

  /// No description provided for @registerSuccess.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام موفق بود. وارد شوید.'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In fa, this message translates to:
  /// **'ثبت‌نام ناموفق بود. دوباره تلاش کنید.'**
  String get registerFailed;

  /// No description provided for @noAccount.
  ///
  /// In fa, this message translates to:
  /// **'حساب ندارید؟'**
  String get noAccount;

  /// No description provided for @hasAccount.
  ///
  /// In fa, this message translates to:
  /// **'قبلاً ثبت‌نام کرده‌اید؟'**
  String get hasAccount;

  /// No description provided for @emailInvalid.
  ///
  /// In fa, this message translates to:
  /// **'ایمیل معتبر وارد کنید.'**
  String get emailInvalid;

  /// No description provided for @passwordMinLength.
  ///
  /// In fa, this message translates to:
  /// **'رمز عبور باید حداقل {min} کاراکتر باشد.'**
  String passwordMinLength(int min);

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
  /// **'تأیید هویت برای باز کردن IP Note'**
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

  /// No description provided for @languagePickerTitle.
  ///
  /// In fa, this message translates to:
  /// **'زبان خود را انتخاب کنید'**
  String get languagePickerTitle;

  /// No description provided for @languagePickerSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'برای تجربهٔ بهتر، زبان رابط کاربر را مشخص کنید'**
  String get languagePickerSubtitle;

  /// No description provided for @languagePickerContinue.
  ///
  /// In fa, this message translates to:
  /// **'ادامه'**
  String get languagePickerContinue;

  /// No description provided for @splashVersion.
  ///
  /// In fa, this message translates to:
  /// **'نسخه {version}'**
  String splashVersion(String version);

  /// No description provided for @plainText.
  ///
  /// In fa, this message translates to:
  /// **'کپی IP خام'**
  String get plainText;

  /// No description provided for @plainCopied.
  ///
  /// In fa, this message translates to:
  /// **'کپی شد'**
  String get plainCopied;

  /// No description provided for @historyRemove.
  ///
  /// In fa, this message translates to:
  /// **'حذف'**
  String get historyRemove;

  /// No description provided for @historySync.
  ///
  /// In fa, this message translates to:
  /// **'همگام‌سازی با حساب…'**
  String get historySync;

  /// No description provided for @codeTitle.
  ///
  /// In fa, this message translates to:
  /// **'نمونه کد دریافت IP'**
  String get codeTitle;

  /// No description provided for @codeHint.
  ///
  /// In fa, this message translates to:
  /// **'برای یکپارچه‌سازی در برنامهٔ شما'**
  String get codeHint;

  /// No description provided for @codeCopy.
  ///
  /// In fa, this message translates to:
  /// **'کپی کد'**
  String get codeCopy;

  /// No description provided for @codeTabCsharp.
  ///
  /// In fa, this message translates to:
  /// **'C#'**
  String get codeTabCsharp;

  /// No description provided for @codeTabJavascript.
  ///
  /// In fa, this message translates to:
  /// **'JavaScript'**
  String get codeTabJavascript;

  /// No description provided for @codeTabPython.
  ///
  /// In fa, this message translates to:
  /// **'Python'**
  String get codeTabPython;

  /// No description provided for @codeTabBash.
  ///
  /// In fa, this message translates to:
  /// **'Bash'**
  String get codeTabBash;

  /// No description provided for @deviceBrowser.
  ///
  /// In fa, this message translates to:
  /// **'مرورگر'**
  String get deviceBrowser;

  /// No description provided for @deviceOs.
  ///
  /// In fa, this message translates to:
  /// **'سیستم‌عامل'**
  String get deviceOs;

  /// No description provided for @deviceType.
  ///
  /// In fa, this message translates to:
  /// **'نوع دستگاه'**
  String get deviceType;

  /// No description provided for @deviceLanguage.
  ///
  /// In fa, this message translates to:
  /// **'زبان'**
  String get deviceLanguage;

  /// No description provided for @toolsHubWhois.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS و امنیت IP'**
  String get toolsHubWhois;

  /// No description provided for @toolsHubWhoisDesc.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS، لیست سیاه و VPN/پروکسی'**
  String get toolsHubWhoisDesc;

  /// No description provided for @toolsHubDns.
  ///
  /// In fa, this message translates to:
  /// **'بررسی DNS'**
  String get toolsHubDns;

  /// No description provided for @toolsHubDnsDesc.
  ///
  /// In fa, this message translates to:
  /// **'رکوردهای DNS یک دامنه'**
  String get toolsHubDnsDesc;

  /// No description provided for @toolsHubPropagation.
  ///
  /// In fa, this message translates to:
  /// **'انتشار DNS'**
  String get toolsHubPropagation;

  /// No description provided for @toolsHubPropagationDesc.
  ///
  /// In fa, this message translates to:
  /// **'مقایسهٔ ریزالورهای عمومی'**
  String get toolsHubPropagationDesc;

  /// No description provided for @toolsHubPort.
  ///
  /// In fa, this message translates to:
  /// **'پورت و SSL'**
  String get toolsHubPort;

  /// No description provided for @toolsHubPortDesc.
  ///
  /// In fa, this message translates to:
  /// **'بررسی پورت باز و گواهی SSL'**
  String get toolsHubPortDesc;

  /// No description provided for @toolsHubWhoisDomain.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS دامنه'**
  String get toolsHubWhoisDomain;

  /// No description provided for @toolsHubWhoisDomainDesc.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات ثبت دامنه'**
  String get toolsHubWhoisDomainDesc;

  /// No description provided for @toolsWhois.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS / RDAP'**
  String get toolsWhois;

  /// No description provided for @toolsWhoisRun.
  ///
  /// In fa, this message translates to:
  /// **'اجرای WHOIS'**
  String get toolsWhoisRun;

  /// No description provided for @toolsBlacklist.
  ///
  /// In fa, this message translates to:
  /// **'لیست سیاه DNSBL'**
  String get toolsBlacklist;

  /// No description provided for @toolsPrivacy.
  ///
  /// In fa, this message translates to:
  /// **'VPN / پروکسی / موبایل'**
  String get toolsPrivacy;

  /// No description provided for @toolsListed.
  ///
  /// In fa, this message translates to:
  /// **'در لیست'**
  String get toolsListed;

  /// No description provided for @toolsClean.
  ///
  /// In fa, this message translates to:
  /// **'پاک'**
  String get toolsClean;

  /// No description provided for @toolsCidr.
  ///
  /// In fa, this message translates to:
  /// **'CIDR'**
  String get toolsCidr;

  /// No description provided for @toolsSubnet.
  ///
  /// In fa, this message translates to:
  /// **'محاسبهٔ زیرشبکه'**
  String get toolsSubnet;

  /// No description provided for @toolsWhoisDomain.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS دامنه'**
  String get toolsWhoisDomain;

  /// No description provided for @toolsPort.
  ///
  /// In fa, this message translates to:
  /// **'بررسی پورت'**
  String get toolsPort;

  /// No description provided for @toolsSsl.
  ///
  /// In fa, this message translates to:
  /// **'گواهی SSL'**
  String get toolsSsl;

  /// No description provided for @toolsPortOpen.
  ///
  /// In fa, this message translates to:
  /// **'باز'**
  String get toolsPortOpen;

  /// No description provided for @toolsPortClosed.
  ///
  /// In fa, this message translates to:
  /// **'بسته'**
  String get toolsPortClosed;

  /// No description provided for @dnsDomain.
  ///
  /// In fa, this message translates to:
  /// **'نام دامنه'**
  String get dnsDomain;

  /// No description provided for @dnsResolve.
  ///
  /// In fa, this message translates to:
  /// **'بررسی DNS'**
  String get dnsResolve;

  /// No description provided for @dnsType.
  ///
  /// In fa, this message translates to:
  /// **'نوع رکورد'**
  String get dnsType;

  /// No description provided for @dnsPropagationCheck.
  ///
  /// In fa, this message translates to:
  /// **'بررسی انتشار'**
  String get dnsPropagationCheck;

  /// No description provided for @dnsMatches.
  ///
  /// In fa, this message translates to:
  /// **'هم‌خوان'**
  String get dnsMatches;

  /// No description provided for @dnsDiffers.
  ///
  /// In fa, this message translates to:
  /// **'متفاوت'**
  String get dnsDiffers;

  /// No description provided for @domainToolsTitle.
  ///
  /// In fa, this message translates to:
  /// **'بررسی دامنه'**
  String get domainToolsTitle;

  /// No description provided for @domainToolsDesc.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS، DNS، انتشار، پورت و SSL در یک صفحه'**
  String get domainToolsDesc;

  /// No description provided for @domainToolsRunAll.
  ///
  /// In fa, this message translates to:
  /// **'اجرای همه بررسی‌های دامنه'**
  String get domainToolsRunAll;

  /// No description provided for @domainTabWhois.
  ///
  /// In fa, this message translates to:
  /// **'WHOIS'**
  String get domainTabWhois;

  /// No description provided for @domainTabDns.
  ///
  /// In fa, this message translates to:
  /// **'DNS'**
  String get domainTabDns;

  /// No description provided for @domainTabPropagation.
  ///
  /// In fa, this message translates to:
  /// **'انتشار'**
  String get domainTabPropagation;

  /// No description provided for @domainTabPortSsl.
  ///
  /// In fa, this message translates to:
  /// **'پورت / SSL'**
  String get domainTabPortSsl;

  /// No description provided for @domainTabEmpty.
  ///
  /// In fa, this message translates to:
  /// **'ابتدا دکمهٔ اجرا را بزنید یا دامنه را وارد کنید.'**
  String get domainTabEmpty;

  /// No description provided for @introTitle.
  ///
  /// In fa, this message translates to:
  /// **'معرفی'**
  String get introTitle;

  /// No description provided for @introBody.
  ///
  /// In fa, this message translates to:
  /// **'IP Note — جستجو، یادداشت و ابزار IP برای وب و موبایل.'**
  String get introBody;

  /// No description provided for @footerChangelog.
  ///
  /// In fa, this message translates to:
  /// **'تغییرات'**
  String get footerChangelog;

  /// No description provided for @footerStatus.
  ///
  /// In fa, this message translates to:
  /// **'وضعیت سرویس'**
  String get footerStatus;

  /// No description provided for @aboutTitle.
  ///
  /// In fa, this message translates to:
  /// **'درباره ما'**
  String get aboutTitle;

  /// No description provided for @aboutSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'IP Note — محصول NTK'**
  String get aboutSubtitle;

  /// No description provided for @aboutProductTitle.
  ///
  /// In fa, this message translates to:
  /// **'IP Note چیست؟'**
  String get aboutProductTitle;

  /// No description provided for @aboutProductBody.
  ///
  /// In fa, this message translates to:
  /// **'سامانه‌ای برای مشاهده IP عمومی، جزئیات شبکه، یادداشت‌برداری و ابزارهای DNS/WHOIS.'**
  String get aboutProductBody;

  /// No description provided for @aboutFeatureLookup.
  ///
  /// In fa, this message translates to:
  /// **'جستجوی IP، Geo، ASN و نقشه'**
  String get aboutFeatureLookup;

  /// No description provided for @aboutFeatureNotes.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت شخصی روی IP'**
  String get aboutFeatureNotes;

  /// No description provided for @aboutFeatureTools.
  ///
  /// In fa, this message translates to:
  /// **'DNS، WHOIS، پورت، SSL و subnet'**
  String get aboutFeatureTools;

  /// No description provided for @aboutFeatureMobile.
  ///
  /// In fa, this message translates to:
  /// **'اپ موبایل با تم روشن/تاریک'**
  String get aboutFeatureMobile;

  /// No description provided for @aboutNtkTitle.
  ///
  /// In fa, this message translates to:
  /// **'NTK'**
  String get aboutNtkTitle;

  /// No description provided for @aboutNtkBody.
  ///
  /// In fa, this message translates to:
  /// **'NTK از سال ۱۳۸۷ در حوزه IT، توسعه نرم‌افزار و میزبانی وب فعال است.'**
  String get aboutNtkBody;

  /// No description provided for @aboutAuthorTitle.
  ///
  /// In fa, this message translates to:
  /// **'علیرضا کاروی'**
  String get aboutAuthorTitle;

  /// No description provided for @aboutAuthorBody.
  ///
  /// In fa, this message translates to:
  /// **'برنامه‌نویس full-stack با تمرکز بر شبکه و امنیت.'**
  String get aboutAuthorBody;

  /// No description provided for @aboutAuthorSkill1.
  ///
  /// In fa, this message translates to:
  /// **'.NET، Angular، Flutter'**
  String get aboutAuthorSkill1;

  /// No description provided for @aboutAuthorSkill2.
  ///
  /// In fa, this message translates to:
  /// **'MikroTik، VoIP، مانیتoring'**
  String get aboutAuthorSkill2;

  /// No description provided for @aboutAuthorSkill3.
  ///
  /// In fa, this message translates to:
  /// **'مدیریت محصول در NTK'**
  String get aboutAuthorSkill3;

  /// No description provided for @aboutEcosystemTitle.
  ///
  /// In fa, this message translates to:
  /// **'پروژه‌های مرتبط'**
  String get aboutEcosystemTitle;

  /// No description provided for @aboutEcosystemHint.
  ///
  /// In fa, this message translates to:
  /// **'برندها و سرویس‌های هم‌خانواده'**
  String get aboutEcosystemHint;

  /// No description provided for @aboutBack.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت به جستجو'**
  String get aboutBack;

  /// No description provided for @copyrightTitle.
  ///
  /// In fa, this message translates to:
  /// **'حقوق نشر'**
  String get copyrightTitle;

  /// No description provided for @copyrightSubtitle.
  ///
  /// In fa, this message translates to:
  /// **'اطلاعات حقوقی IP Note'**
  String get copyrightSubtitle;

  /// No description provided for @copyrightOwnershipTitle.
  ///
  /// In fa, this message translates to:
  /// **'مالکیت'**
  String get copyrightOwnershipTitle;

  /// No description provided for @copyrightOwnershipBody.
  ///
  /// In fa, this message translates to:
  /// **'حقوق IP Note متعلق به NTK / علیرضا کاروی است.'**
  String get copyrightOwnershipBody;

  /// No description provided for @copyrightLicenseTitle.
  ///
  /// In fa, this message translates to:
  /// **'مجوز استفاده'**
  String get copyrightLicenseTitle;

  /// No description provided for @copyrightLicenseBody.
  ///
  /// In fa, this message translates to:
  /// **'استفاده شخصی مجاز است؛ سوءاستفاده و بارگذاری بیش از حد API ممنوع.'**
  String get copyrightLicenseBody;

  /// No description provided for @copyrightTrademarksTitle.
  ///
  /// In fa, this message translates to:
  /// **'علائم تجاری'**
  String get copyrightTrademarksTitle;

  /// No description provided for @copyrightTrademarksBody.
  ///
  /// In fa, this message translates to:
  /// **'IP Note و NTK علامت‌های تجاری مرتبط هستند.'**
  String get copyrightTrademarksBody;

  /// No description provided for @copyrightThirdPartyTitle.
  ///
  /// In fa, this message translates to:
  /// **'سرویس‌های شخص ثالث'**
  String get copyrightThirdPartyTitle;

  /// No description provided for @copyrightThirdPartyBody.
  ///
  /// In fa, this message translates to:
  /// **'داده‌ها از ارائه‌دهندگان Geo/DNS/WHOIS دریافت می‌شوند.'**
  String get copyrightThirdPartyBody;

  /// No description provided for @copyrightPrivacyTitle.
  ///
  /// In fa, this message translates to:
  /// **'حریم خصوصی'**
  String get copyrightPrivacyTitle;

  /// No description provided for @copyrightPrivacyBody.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت‌ها فقط برای کاربر احراز هویت‌شده قابل مشاهده است.'**
  String get copyrightPrivacyBody;

  /// No description provided for @copyrightContactTitle.
  ///
  /// In fa, this message translates to:
  /// **'تماس حقوقی'**
  String get copyrightContactTitle;

  /// No description provided for @copyrightContactBody.
  ///
  /// In fa, this message translates to:
  /// **'برای مجوز تجاری یا DMCA با ایمیل پشتیبانی تماس بگیرید.'**
  String get copyrightContactBody;

  /// No description provided for @copyrightBack.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get copyrightBack;

  /// No description provided for @adminTitle.
  ///
  /// In fa, this message translates to:
  /// **'پنل مدیریت'**
  String get adminTitle;

  /// No description provided for @adminAccessDenied.
  ///
  /// In fa, this message translates to:
  /// **'دسترسی مدیر لازم است.'**
  String get adminAccessDenied;

  /// No description provided for @adminBackToApp.
  ///
  /// In fa, this message translates to:
  /// **'بازگشت'**
  String get adminBackToApp;

  /// No description provided for @adminEmpty.
  ///
  /// In fa, this message translates to:
  /// **'موردی نیست.'**
  String get adminEmpty;

  /// No description provided for @adminConfirmDelete.
  ///
  /// In fa, this message translates to:
  /// **'حذف شود؟'**
  String get adminConfirmDelete;

  /// No description provided for @adminEditRoles.
  ///
  /// In fa, this message translates to:
  /// **'ویرایش نقش‌ها'**
  String get adminEditRoles;

  /// No description provided for @adminRolesHint.
  ///
  /// In fa, this message translates to:
  /// **'Administrator, …'**
  String get adminRolesHint;

  /// No description provided for @adminRolesMembers.
  ///
  /// In fa, this message translates to:
  /// **'عضو'**
  String get adminRolesMembers;

  /// No description provided for @adminRolesPermissionCount.
  ///
  /// In fa, this message translates to:
  /// **'مجوز'**
  String get adminRolesPermissionCount;

  /// No description provided for @adminRolesPermissionsHint.
  ///
  /// In fa, this message translates to:
  /// **'مجوزهای این نقش را انتخاب کنید.'**
  String get adminRolesPermissionsHint;

  /// No description provided for @adminFilterPending.
  ///
  /// In fa, this message translates to:
  /// **'فقط معلق'**
  String get adminFilterPending;

  /// No description provided for @adminNavDashboard.
  ///
  /// In fa, this message translates to:
  /// **'داشبورد'**
  String get adminNavDashboard;

  /// No description provided for @adminNavRoles.
  ///
  /// In fa, this message translates to:
  /// **'نقش‌ها'**
  String get adminNavRoles;

  /// No description provided for @adminNavUsers.
  ///
  /// In fa, this message translates to:
  /// **'کاربران'**
  String get adminNavUsers;

  /// No description provided for @adminNavNotes.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت‌ها'**
  String get adminNavNotes;

  /// No description provided for @adminNavLookups.
  ///
  /// In fa, this message translates to:
  /// **'جستجوها'**
  String get adminNavLookups;

  /// No description provided for @adminNavPush.
  ///
  /// In fa, this message translates to:
  /// **'پوش'**
  String get adminNavPush;

  /// No description provided for @adminNavOutbox.
  ///
  /// In fa, this message translates to:
  /// **'Outbox'**
  String get adminNavOutbox;

  /// No description provided for @adminStatUsers.
  ///
  /// In fa, this message translates to:
  /// **'کاربر'**
  String get adminStatUsers;

  /// No description provided for @adminStatRoles.
  ///
  /// In fa, this message translates to:
  /// **'نقش'**
  String get adminStatRoles;

  /// No description provided for @adminStatNotes.
  ///
  /// In fa, this message translates to:
  /// **'یادداشت'**
  String get adminStatNotes;

  /// No description provided for @adminStatLookups.
  ///
  /// In fa, this message translates to:
  /// **'جستجو'**
  String get adminStatLookups;

  /// No description provided for @adminStatPush.
  ///
  /// In fa, this message translates to:
  /// **'پوش'**
  String get adminStatPush;

  /// No description provided for @adminStatOutbox.
  ///
  /// In fa, this message translates to:
  /// **'Outbox معلق'**
  String get adminStatOutbox;

  /// No description provided for @adminStatTicketsOpen.
  ///
  /// In fa, this message translates to:
  /// **'تیکت باز'**
  String get adminStatTicketsOpen;

  /// No description provided for @adminStatSnapshots.
  ///
  /// In fa, this message translates to:
  /// **'اسنپ‌شات'**
  String get adminStatSnapshots;

  /// No description provided for @adminTicketsOpenOnly.
  ///
  /// In fa, this message translates to:
  /// **'فقط تیکت‌های باز'**
  String get adminTicketsOpenOnly;

  /// No description provided for @adminTicketClose.
  ///
  /// In fa, this message translates to:
  /// **'بستن تیکت'**
  String get adminTicketClose;

  /// No description provided for @adminTicketReopen.
  ///
  /// In fa, this message translates to:
  /// **'بازگشایی تیکت'**
  String get adminTicketReopen;
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
      <String>['ar', 'en', 'fa', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
