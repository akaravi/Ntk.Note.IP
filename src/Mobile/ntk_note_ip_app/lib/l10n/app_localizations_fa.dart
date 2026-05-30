// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'IP Note';

  @override
  String get homeTagline => 'یادداشت و مدیریت اطلاعات IP';

  @override
  String get myIp => 'IP من';

  @override
  String get loading => 'در حال بارگذاری…';

  @override
  String get error => 'خطا';

  @override
  String get retry => 'تلاش مجدد';

  @override
  String get copy => 'کپی';

  @override
  String get copied => 'کپی شد';

  @override
  String get ipv4 => 'IPv4';

  @override
  String get ipv6 => 'IPv6';

  @override
  String get scope => 'محدوده';

  @override
  String get toggleLanguage => 'تغییر زبان';

  @override
  String get toggleTheme => 'تغییر تم';

  @override
  String get loginTitle => 'ورود';

  @override
  String get loginSubtitle => 'برای داشبورد و یادداشت‌های IP وارد شوید';

  @override
  String get loginAction => 'ورود';

  @override
  String get rememberMe => 'مرا به خاطر بسپار ';

  @override
  String get contactTitle => 'تماس با ما';

  @override
  String get contactSubtitle =>
      'پیام خود را بفرستید؛ تیم پشتیبانی در اسرع وقت پاسخ می‌دهد.';

  @override
  String get contactName => 'نام';

  @override
  String get contactSubject => 'موضوع';

  @override
  String get contactMessage => 'پیام';

  @override
  String get contactSubmit => 'ارسال';

  @override
  String get contactSuccess =>
      'پیام شما ثبت شد و ایمیل اطلاع‌رسانی ارسال گردید.';

  @override
  String get contactSuccessNoEmail =>
      'پیام شما ثبت شد. ارسال ایمیل ممکن نبود؛ تیکت در پنل مدیریت ذخیره شده است.';

  @override
  String get contactError => 'ارسال ناموفق بود. لطفاً دوباره تلاش کنید.';

  @override
  String get footerContact => 'تماس با ما';

  @override
  String get adminTicketsTab => 'تیکت‌ها';

  @override
  String get registerTitle => 'ثبت‌نام';

  @override
  String get registerSubtitle => 'حساب جدید برای داشبورد و یادداشت IP';

  @override
  String get registerAction => 'ثبت‌نام';

  @override
  String get registerSuccess => 'ثبت‌نام موفق بود. وارد شوید.';

  @override
  String get registerFailed => 'ثبت‌نام ناموفق بود. دوباره تلاش کنید.';

  @override
  String get noAccount => 'حساب ندارید؟';

  @override
  String get hasAccount => 'قبلاً ثبت‌نام کرده‌اید؟';

  @override
  String get emailInvalid => 'ایمیل معتبر وارد کنید.';

  @override
  String passwordMinLength(int min) {
    return 'رمز عبور باید حداقل $min کاراکتر باشد.';
  }

  @override
  String get email => 'ایمیل';

  @override
  String get password => 'رمز عبور';

  @override
  String get fieldRequired => 'این فیلد الزامی است';

  @override
  String get actionCancel => 'انصراف';

  @override
  String get logout => 'خروج';

  @override
  String get refresh => 'بروزرسانی';

  @override
  String get dashboardTitle => 'داشبورد';

  @override
  String get dashboardSubtitle => 'خط زمانی IPهای مشاهده‌شده (محلی + سرور)';

  @override
  String get dashboardSearch => 'جستجو';

  @override
  String get dashboardTimeline => 'خط زمانی';

  @override
  String get dashboardEmpty => 'موردی یافت نشد.';

  @override
  String get dashboardCountries => 'فیلتر کشور';

  @override
  String get statTotal => 'کل';

  @override
  String get statUniqueIp => 'IP یکتا';

  @override
  String get statCountries => 'کشور';

  @override
  String get statNotes => 'یادداشت';

  @override
  String get exportCsv => 'خروجی CSV';

  @override
  String get exportJson => 'خروجی JSON';

  @override
  String get notesTitle => 'یادداشت IP';

  @override
  String get notesSubtitle => 'یادداشت روی آدرس‌های IP';

  @override
  String get notesListTitle => 'یادداشت‌های من';

  @override
  String get notesEmpty => 'یادداشتی ثبت نشده است.';

  @override
  String get noteAddress => 'آدرس IP';

  @override
  String get noteTitle => 'عنوان';

  @override
  String get noteBody => 'متن';

  @override
  String get noteTags => 'برچسب‌ها (با کاما)';

  @override
  String get noteAdd => 'افزودن یادداشت';

  @override
  String get noteDelete => 'حذف';

  @override
  String get noteEdit => 'ویرایش';

  @override
  String get noteSave => 'ذخیره';

  @override
  String get noteUpdateTitle => 'ویرایش یادداشت';

  @override
  String get useMyIp => 'IP من';

  @override
  String get noteThis => 'یاداشت کن';

  @override
  String get noteSnapshotReady =>
      'زمان، دستگاه و جزئیات IP برای این یادداشت ضمیمه می‌شود.';

  @override
  String get openLookup => 'مشاهده IP';

  @override
  String get lookupAddress => 'جستجوی IP';

  @override
  String get localIp => 'IP محلی (Wi‑Fi)';

  @override
  String get showQr => 'نمایش QR';

  @override
  String get openMap => 'باز کردن در OpenStreetMap';

  @override
  String get geoTitle => 'موقعیت جغرافیایی';

  @override
  String get country => 'کشور';

  @override
  String get region => 'شهر / منطقه';

  @override
  String get timezone => 'منطقهٔ زمانی';

  @override
  String get networkTitle => 'شبکه و ISP';

  @override
  String get isp => 'ISP';

  @override
  String get asn => 'ASN';

  @override
  String get organization => 'سازمان';

  @override
  String get reverseDns => 'Reverse DNS';

  @override
  String get deviceTitle => 'دستگاه';

  @override
  String get recentHistory => 'تاریخچهٔ اخیر';

  @override
  String get historyClear => 'پاک کردن';

  @override
  String get cmdTitle => 'دستور دریافت IP';

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
  String get toolsTitle => 'ابزارها';

  @override
  String get toolsSubtitle => 'ابزارهای شبکه و مقایسه IP';

  @override
  String get toolsHubLookup => 'جستجوی IP';

  @override
  String get toolsHubLookupDesc => 'بازگشت به صفحهٔ اصلی برای جزئیات IP';

  @override
  String get toolsCompareTitle => 'مقایسهٔ دو IP';

  @override
  String get toolsCompareA => 'IP اول';

  @override
  String get toolsCompareB => 'IP دوم';

  @override
  String get toolsCompareRun => 'مقایسه';

  @override
  String get compareAddress => 'آدرس';

  @override
  String get compareGeo => 'موقعیت';

  @override
  String get compareIsp => 'ISP';

  @override
  String get compareAsn => 'ASN';

  @override
  String get compareReverseDns => 'Reverse DNS';

  @override
  String get compareScope => 'محدوده';

  @override
  String get biometricLockTitle => 'اپ قفل است';

  @override
  String get biometricLockSubtitle =>
      'برای ادامه، اثر انگشت یا Face ID را تأیید کنید';

  @override
  String get biometricUnlockAction => 'باز کردن قفل';

  @override
  String get biometricUnlockReason => 'تأیید هویت برای باز کردن IP Note';

  @override
  String get biometricUnlockFailed => 'احراز هویت ناموفق بود';

  @override
  String get biometricSettingTitle => 'باز کردن با اثر انگشت';

  @override
  String get biometricSettingSubtitle =>
      'هنگام بازگشت به اپ، قفل بیومتریک نمایش داده می‌شود';

  @override
  String get biometricUnavailable =>
      'احراز هویت بیومتریک روی این دستگاه در دسترس نیست';

  @override
  String get backgroundMonitorTitle => 'مانیتور تغییر IP در پس‌زمینه';

  @override
  String get backgroundMonitorSubtitle =>
      'هر ۳۰ دقیقه IP عمومی را بررسی می‌کند و در صورت تغییر اعلان می‌دهد';

  @override
  String get notificationPermissionDenied =>
      'برای اعلان تغییر IP، مجوز اعلان لازم است';

  @override
  String backgroundIpChangedNotification(String address) {
    return 'IP عمومی شما به $address تغییر کرد';
  }

  @override
  String get languagePickerTitle => 'زبان خود را انتخاب کنید';

  @override
  String get languagePickerSubtitle =>
      'برای تجربهٔ بهتر، زبان رابط کاربر را مشخص کنید';

  @override
  String get languagePickerContinue => 'ادامه';

  @override
  String splashVersion(String version) {
    return 'نسخه $version';
  }

  @override
  String get plainText => 'کپی IP خام';

  @override
  String get plainCopied => 'کپی شد';

  @override
  String get historyRemove => 'حذف';

  @override
  String get historySync => 'همگام‌سازی با حساب…';

  @override
  String get codeTitle => 'نمونه کد دریافت IP';

  @override
  String get codeHint => 'برای یکپارچه‌سازی در برنامهٔ شما';

  @override
  String get codeCopy => 'کپی کد';

  @override
  String get codeTabCsharp => 'C#';

  @override
  String get codeTabJavascript => 'JavaScript';

  @override
  String get codeTabPython => 'Python';

  @override
  String get codeTabBash => 'Bash';

  @override
  String get deviceBrowser => 'مرورگر';

  @override
  String get deviceOs => 'سیستم‌عامل';

  @override
  String get deviceType => 'نوع دستگاه';

  @override
  String get deviceLanguage => 'زبان';

  @override
  String get noteRecordedAt => 'زمان ثبت';

  @override
  String get noteJustNow => 'همین الان';

  @override
  String noteMinutesAgo(int count) {
    return '$count دقیقه پیش';
  }

  @override
  String noteHoursAgo(int count) {
    return '$count ساعت پیش';
  }

  @override
  String get toolsHubWhois => 'WHOIS و امنیت IP';

  @override
  String get toolsHubWhoisDesc => 'WHOIS، لیست سیاه و VPN/پروکسی';

  @override
  String get toolsHubDns => 'بررسی DNS';

  @override
  String get toolsHubDnsDesc => 'رکوردهای DNS یک دامنه';

  @override
  String get toolsHubPropagation => 'انتشار DNS';

  @override
  String get toolsHubPropagationDesc => 'مقایسهٔ ریزالورهای عمومی';

  @override
  String get toolsHubPort => 'پورت و SSL';

  @override
  String get toolsHubPortDesc => 'بررسی پورت باز و گواهی SSL';

  @override
  String get toolsHubWhoisDomain => 'WHOIS دامنه';

  @override
  String get toolsHubWhoisDomainDesc => 'اطلاعات ثبت دامنه';

  @override
  String get toolsWhois => 'WHOIS / RDAP';

  @override
  String get toolsWhoisRun => 'اجرای WHOIS';

  @override
  String get toolsBlacklist => 'لیست سیاه DNSBL';

  @override
  String get toolsPrivacy => 'VPN / پروکسی / موبایل';

  @override
  String get toolsListed => 'در لیست';

  @override
  String get toolsClean => 'پاک';

  @override
  String get toolsCidr => 'CIDR';

  @override
  String get toolsSubnet => 'محاسبهٔ زیرشبکه';

  @override
  String get toolsWhoisDomain => 'WHOIS دامنه';

  @override
  String get toolsPort => 'بررسی پورت';

  @override
  String get toolsSsl => 'گواهی SSL';

  @override
  String get toolsPortOpen => 'باز';

  @override
  String get toolsPortClosed => 'بسته';

  @override
  String get dnsDomain => 'نام دامنه';

  @override
  String get dnsResolve => 'بررسی DNS';

  @override
  String get dnsType => 'نوع رکورد';

  @override
  String get dnsPropagationCheck => 'بررسی انتشار';

  @override
  String get dnsMatches => 'هم‌خوان';

  @override
  String get dnsDiffers => 'متفاوت';

  @override
  String get domainToolsTitle => 'بررسی دامنه';

  @override
  String get domainToolsDesc => 'WHOIS، DNS، انتشار، پورت و SSL در یک صفحه';

  @override
  String get domainToolsRunAll => 'اجرای همه بررسی‌های دامنه';

  @override
  String get domainTabWhois => 'WHOIS';

  @override
  String get domainTabDns => 'DNS';

  @override
  String get domainTabPropagation => 'انتشار';

  @override
  String get domainTabPortSsl => 'پورت / SSL';

  @override
  String get domainTabEmpty =>
      'ابتدا دکمهٔ اجرا را بزنید یا دامنه را وارد کنید.';

  @override
  String get introTitle => 'معرفی';

  @override
  String get introBody =>
      'IP Note — جستجو، یادداشت و ابزار IP برای وب و موبایل.';

  @override
  String get footerChangelog => 'تغییرات';

  @override
  String get footerStatus => 'وضعیت سرویس';

  @override
  String get aboutTitle => 'درباره ما';

  @override
  String get aboutSubtitle => 'IP Note — محصول NTK';

  @override
  String get aboutProductTitle => 'IP Note چیست؟';

  @override
  String get aboutProductBody =>
      'سامانه‌ای برای مشاهده IP عمومی، جزئیات شبکه، یادداشت‌برداری و ابزارهای DNS/WHOIS.';

  @override
  String get aboutFeatureLookup => 'جستجوی IP، Geo، ASN و نقشه';

  @override
  String get aboutFeatureNotes => 'یادداشت شخصی روی IP';

  @override
  String get aboutFeatureTools => 'DNS، WHOIS، پورت، SSL و subnet';

  @override
  String get aboutFeatureMobile => 'اپ موبایل با تم روشن/تاریک';

  @override
  String get aboutNtkTitle => 'NTK';

  @override
  String get aboutNtkBody =>
      'NTK از سال ۱۳۸۷ در حوزه IT، توسعه نرم‌افزار و میزبانی وب فعال است.';

  @override
  String get aboutAuthorTitle => 'علیرضا کاروی';

  @override
  String get aboutAuthorBody =>
      'برنامه‌نویس full-stack با تمرکز بر شبکه و امنیت.';

  @override
  String get aboutAuthorSkill1 => '.NET، Angular، Flutter';

  @override
  String get aboutAuthorSkill2 => 'MikroTik، VoIP، مانیتoring';

  @override
  String get aboutAuthorSkill3 => 'مدیریت محصول در NTK';

  @override
  String get aboutEcosystemTitle => 'پروژه‌های مرتبط';

  @override
  String get aboutEcosystemHint => 'برندها و سرویس‌های هم‌خانواده';

  @override
  String get aboutBack => 'بازگشت به جستجو';

  @override
  String get copyrightTitle => 'حقوق نشر';

  @override
  String get copyrightSubtitle => 'اطلاعات حقوقی IP Note';

  @override
  String get copyrightOwnershipTitle => 'مالکیت';

  @override
  String get copyrightOwnershipBody =>
      'حقوق IP Note متعلق به NTK / علیرضا کاروی است.';

  @override
  String get copyrightLicenseTitle => 'مجوز استفاده';

  @override
  String get copyrightLicenseBody =>
      'استفاده شخصی مجاز است؛ سوءاستفاده و بارگذاری بیش از حد API ممنوع.';

  @override
  String get copyrightTrademarksTitle => 'علائم تجاری';

  @override
  String get copyrightTrademarksBody =>
      'IP Note و NTK علامت‌های تجاری مرتبط هستند.';

  @override
  String get copyrightThirdPartyTitle => 'سرویس‌های شخص ثالث';

  @override
  String get copyrightThirdPartyBody =>
      'داده‌ها از ارائه‌دهندگان Geo/DNS/WHOIS دریافت می‌شوند.';

  @override
  String get copyrightPrivacyTitle => 'حریم خصوصی';

  @override
  String get copyrightPrivacyBody =>
      'یادداشت‌ها فقط برای کاربر احراز هویت‌شده قابل مشاهده است.';

  @override
  String get copyrightContactTitle => 'تماس حقوقی';

  @override
  String get copyrightContactBody =>
      'برای مجوز تجاری یا DMCA با ایمیل پشتیبانی تماس بگیرید.';

  @override
  String get copyrightBack => 'بازگشت';

  @override
  String get adminTitle => 'پنل مدیریت';

  @override
  String get adminAccessDenied => 'دسترسی مدیر لازم است.';

  @override
  String get adminBackToApp => 'بازگشت';

  @override
  String get adminEmpty => 'موردی نیست.';

  @override
  String get adminConfirmDelete => 'حذف شود؟';

  @override
  String get adminEditRoles => 'ویرایش نقش‌ها';

  @override
  String get adminRolesHint => 'Administrator, …';

  @override
  String get adminRolesMembers => 'عضو';

  @override
  String get adminRolesPermissionCount => 'مجوز';

  @override
  String get adminRolesPermissionsHint => 'مجوزهای این نقش را انتخاب کنید.';

  @override
  String get adminFilterPending => 'فقط معلق';

  @override
  String get adminNavDashboard => 'داشبورد';

  @override
  String get adminNavRoles => 'نقش‌ها';

  @override
  String get adminNavUsers => 'کاربران';

  @override
  String get adminNavNotes => 'یادداشت‌ها';

  @override
  String get adminNavLookups => 'جستجوها';

  @override
  String get adminNavPush => 'پوش';

  @override
  String get adminNavOutbox => 'Outbox';

  @override
  String get adminStatUsers => 'کاربر';

  @override
  String get adminStatRoles => 'نقش';

  @override
  String get adminStatNotes => 'یادداشت';

  @override
  String get adminStatLookups => 'جستجو';

  @override
  String get adminStatPush => 'پوش';

  @override
  String get adminStatOutbox => 'Outbox معلق';

  @override
  String get adminStatTicketsOpen => 'تیکت باز';

  @override
  String get adminStatSnapshots => 'اسنپ‌شات';

  @override
  String get adminTicketsOpenOnly => 'فقط تیکت‌های باز';

  @override
  String get adminTicketClose => 'بستن تیکت';

  @override
  String get adminTicketReopen => 'بازگشایی تیکت';
}
