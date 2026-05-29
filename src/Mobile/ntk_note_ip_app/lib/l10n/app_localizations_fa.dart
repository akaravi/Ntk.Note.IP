// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Persian (`fa`).
class AppLocalizationsFa extends AppLocalizations {
  AppLocalizationsFa([String locale = 'fa']) : super(locale);

  @override
  String get appTitle => 'IPNote.ir';

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
  String get biometricUnlockReason => 'تأیید هویت برای باز کردن IPNote.ir';

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
}
