// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'IP Note';

  @override
  String get homeTagline => 'ملاحظات IP وذكاء الشبكة';

  @override
  String get myIp => 'عنوان IP الخاص بي';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get copy => 'نسخ';

  @override
  String get copied => 'تم النسخ';

  @override
  String get ipv4 => 'IPv4';

  @override
  String get ipv6 => 'IPv6';

  @override
  String get scope => 'النطاق';

  @override
  String get toggleLanguage => 'تغيير اللغة';

  @override
  String get toggleTheme => 'تغيير المظهر';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get loginSubtitle => 'سجّل الدخول للوحة التحكم وملاحظات IP';

  @override
  String get loginAction => 'تسجيل الدخول';

  @override
  String get rememberMe => 'تذكرني (شهر واحد)';

  @override
  String get contactTitle => 'اتصل بنا';

  @override
  String get contactSubtitle => 'أرسل رسالتك — سيرد فريق الدعم في أقرب وقت.';

  @override
  String get contactName => 'الاسم';

  @override
  String get contactSubject => 'الموضوع';

  @override
  String get contactMessage => 'الرسالة';

  @override
  String get contactSubmit => 'إرسال';

  @override
  String get contactSuccess => 'تم حفظ رسالتك وإرسال بريد إشعار.';

  @override
  String get contactSuccessNoEmail =>
      'تم حفظ رسالتك. تعذر إرسال البريد؛ التذكرة محفوظة في الإدارة.';

  @override
  String get contactError => 'فشل الإرسال. حاول مرة أخرى.';

  @override
  String get footerContact => 'اتصل بنا';

  @override
  String get adminTicketsTab => 'التذاكر';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'حساب جديد للوحة التحكم وملاحظات IP';

  @override
  String get registerAction => 'إنشاء حساب';

  @override
  String get registerSuccess => 'تم التسجيل بنجاح. يُرجى تسجيل الدخول.';

  @override
  String get registerFailed => 'فشل التسجيل. حاول مرة أخرى.';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get hasAccount => 'لديك حساب بالفعل؟';

  @override
  String get emailInvalid => 'أدخل بريدًا إلكترونيًا صالحًا.';

  @override
  String passwordMinLength(int min) {
    return 'يجب أن تكون كلمة المرور $min أحرف على الأقل.';
  }

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get refresh => 'تحديث';

  @override
  String get dashboardTitle => 'لوحة التحكم';

  @override
  String get dashboardSubtitle => 'الخط الزمني لعناوين IP (محلي + خادم)';

  @override
  String get dashboardSearch => 'بحث';

  @override
  String get dashboardTimeline => 'الخط الزمني';

  @override
  String get dashboardEmpty => 'لم يتم العثور على عناصر.';

  @override
  String get dashboardCountries => 'تصفية حسب الدولة';

  @override
  String get statTotal => 'الإجمالي';

  @override
  String get statUniqueIp => 'IP فريدة';

  @override
  String get statCountries => 'الدول';

  @override
  String get statNotes => 'ملاحظات';

  @override
  String get exportCsv => 'تصدير CSV';

  @override
  String get exportJson => 'تصدير JSON';

  @override
  String get notesTitle => 'ملاحظات IP';

  @override
  String get notesSubtitle => 'ملاحظات مرتبطة بعناوين IP';

  @override
  String get notesListTitle => 'ملاحظاتي';

  @override
  String get notesEmpty => 'لا توجد ملاحظات بعد.';

  @override
  String get noteAddress => 'عنوان IP';

  @override
  String get noteTitle => 'العنوان';

  @override
  String get noteBody => 'النص';

  @override
  String get noteTags => 'الوسوم (مفصولة بفاصلة)';

  @override
  String get noteAdd => 'إضافة ملاحظة';

  @override
  String get noteDelete => 'حذف';

  @override
  String get noteEdit => 'تعديل';

  @override
  String get noteSave => 'حفظ';

  @override
  String get noteUpdateTitle => 'تعديل الملاحظة';

  @override
  String get useMyIp => 'عنوان IP الخاص بي';

  @override
  String get noteThis => 'أضف ملاحظة';

  @override
  String get noteSnapshotReady =>
      'سيتم إرفاق الوقت والجهاز وتفاصيل IP بهذه الملاحظة.';

  @override
  String get openLookup => 'عرض IP';

  @override
  String get lookupAddress => 'البحث عن IP';

  @override
  String get localIp => 'IP محلي (Wi‑Fi)';

  @override
  String get showQr => 'عرض QR';

  @override
  String get openMap => 'فتح في OpenStreetMap';

  @override
  String get geoTitle => 'الموقع الجغرافي';

  @override
  String get country => 'الدولة';

  @override
  String get region => 'المدينة / المنطقة';

  @override
  String get timezone => 'المنطقة الزمنية';

  @override
  String get networkTitle => 'الشبكة ومزود الخدمة';

  @override
  String get isp => 'مزود الخدمة';

  @override
  String get asn => 'ASN';

  @override
  String get organization => 'المؤسسة';

  @override
  String get reverseDns => 'DNS عكسي';

  @override
  String get deviceTitle => 'الجهاز';

  @override
  String get recentHistory => 'السجل الأخير';

  @override
  String get historyClear => 'مسح';

  @override
  String get cmdTitle => 'أمر الحصول على IP';

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
  String get toolsTitle => 'الأدوات';

  @override
  String get toolsSubtitle => 'أدوات الشبكة ومقارنة IP';

  @override
  String get toolsHubLookup => 'بحث IP';

  @override
  String get toolsHubLookupDesc => 'العودة إلى الرئيسية لتفاصيل IP الكاملة';

  @override
  String get toolsCompareTitle => 'مقارنة عنوانين IP';

  @override
  String get toolsCompareA => 'IP الأول';

  @override
  String get toolsCompareB => 'IP الثاني';

  @override
  String get toolsCompareRun => 'مقارنة';

  @override
  String get compareAddress => 'العنوان';

  @override
  String get compareGeo => 'الموقع';

  @override
  String get compareIsp => 'مزود الخدمة';

  @override
  String get compareAsn => 'ASN';

  @override
  String get compareReverseDns => 'DNS عكسي';

  @override
  String get compareScope => 'النطاق';

  @override
  String get biometricLockTitle => 'التطبيق مقفل';

  @override
  String get biometricLockSubtitle => 'أكّد ببصمة الإصبع أو Face ID للمتابعة';

  @override
  String get biometricUnlockAction => 'فتح القفل';

  @override
  String get biometricUnlockReason => 'تحقق من هويتك لفتح IP Note';

  @override
  String get biometricUnlockFailed => 'فشل التحقق';

  @override
  String get biometricSettingTitle => 'فتح بالبصمة';

  @override
  String get biometricSettingSubtitle =>
      'عرض قفل بيومتري عند العودة إلى التطبيق';

  @override
  String get biometricUnavailable =>
      'المصادقة البيومترية غير متاحة على هذا الجهاز';

  @override
  String get backgroundMonitorTitle => 'مراقبة IP في الخلفية';

  @override
  String get backgroundMonitorSubtitle =>
      'يفحص IP العام كل 30 دقيقة تقريبًا ويُبلّغ عند التغيير';

  @override
  String get notificationPermissionDenied =>
      'إذن الإشعارات مطلوب لتنبيهات تغيير IP';

  @override
  String backgroundIpChangedNotification(String address) {
    return 'تغيّر IP العام إلى $address';
  }

  @override
  String get languagePickerTitle => 'اختر لغتك';

  @override
  String get languagePickerSubtitle =>
      'حدّد لغة واجهة التطبيق للحصول على تجربة أفضل';

  @override
  String get languagePickerContinue => 'متابعة';

  @override
  String splashVersion(String version) {
    return 'الإصدار $version';
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
  String get noteRecordedAt => 'وقت التسجيل';

  @override
  String get noteJustNow => 'الآن';

  @override
  String noteMinutesAgo(int count) {
    return 'قبل $count دقيقة';
  }

  @override
  String noteHoursAgo(int count) {
    return 'قبل $count ساعة';
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
  String get domainToolsDesc => 'WHOIS، DNS، انتشار، پورت و SSL';

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
  String get domainTabEmpty => 'ابتدا دکمهٔ اجرا را بزنید.';

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
  String get adminRolesPermissionsHint => 'اختر أذونات هذا الدور.';

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
  String get adminStatTicketsOpen => 'تذاكر مفتوحة';

  @override
  String get adminStatSnapshots => 'اسنپ‌شات';

  @override
  String get adminTicketsOpenOnly => 'المفتوحة فقط';

  @override
  String get adminTicketClose => 'إغلاق';

  @override
  String get adminTicketReopen => 'إعادة فتح';
}
