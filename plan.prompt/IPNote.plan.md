# IPNote.ir — پلن نهایی پیاده‌سازی (Cursor Final Plan)

> Solution: `Ntk.Note.IP` | مسیر سورس: `D:\SourceKaravi\GitHub\Ntk.Note.IP`
> بک‌اند: C# / .NET 10, Clean Architecture | معماری: API-First (یک بک‌اند مشترک برای وب + Flutter)
> کلاینت‌ها: Web (IPNote.ir), Flutter App (Android, iOS) | زبان پایه: fa (Persian) + en
> تعداد مراحل: 10 | مجموع زیربرنامه‌ها: **1000** | تولید: 2026-05-29 07:48 UTC

> یادآوری: سورس روی درایو محلی است و در این سند بر پایهٔ چیدمان استاندارد Clean Architecture فرض شده؛ Stage 0 شامل تطبیق با کد واقعی است.

---

## کنوانسیون‌های الزامی (Conventions)

- زبان توضیحات و راهنما: فارسی.
- زبان برنامه‌نویسی اصلی بک‌اند: C# (.NET 10) با Clean Architecture.
- منطق بیزینسی در کنترلر نوشته نشود؛ در لایهٔ Application باشد.
- نام‌گذاری: PascalCase برای کلاس/متد، camelCase برای متغیر لوکال.
- قبل از تغییر هر فایل، diff کامل پیشنهادی نشان داده شود.
- هر تغییر با تاریخ/زمان در readmehistory ثبت شود.
- تغییرات یک‌به‌یک اعمال شوند، نه یکجا.
- پس از هر تغییر، بررسی خطا (build/test/lint) انجام شود.
- در پروژهٔ چندزبانه، کامل‌بودن ترجمه‌ها در همهٔ فایل‌های زبان بررسی شود؛ زبان پایه فارسی است.
- تم تاریک/روشن و طراحی واکنش‌گرا (موبایل/دسکتاپ) رعایت شود.
- هر پلن در قالب Cursor.XX.plan.md، با هدر Part X و Result X.
- اگر پاسخ سؤال پیشرفت 'continue' بود، خودکار ادامه بده.
- از مثال‌های C# و JavaScript در توضیحات فنی استفاده شود.
- برای شبکه/VPN فرض بر MikroTik RouterOS 7.x است.
- کد خوانا، باکیفیت و قابل‌نگهداری با بهترین‌روش‌های استاندارد.

## معماری (Architecture)

**پروژه‌های بک‌اند:**

- Ntk.Note.IP.Domain — موجودیت‌ها، Value Objectها، قواعد دامنه
- Ntk.Note.IP.Application — CQRS، Handlerها، Validation، DTO، Interfaceها
- Ntk.Note.IP.Infrastructure — EF Core، Repository، Providerهای بیرونی IP/Geo/ASN، Cache، Jobs
- Ntk.Note.IP.Api — Minimal API/Controllers، Auth، OpenAPI، Middlewareها
- Ntk.Note.IP.Shared — مدل‌های مشترک قرارداد (Contracts/DTO)
- Ntk.Note.IP.Web — کلاینت وب (در فاز معماری نهایی: Blazor یا SPA)
- tests/* — Unit/Integration/Functional

**اپ Flutter:** ntk_note_ip_app — Clean Architecture (presentation/domain/data)، Riverpod یا Bloc، Dio، مدل‌های تولیدشده از OpenAPI

**جریان داده:** Client → Api → Application(CQRS) → Domain / Infrastructure → DB + External IP services


---

## Part 1 — محیط، ابزار، مخزن و کنوانسیون‌ها (`S0`)

**هدف:** آماده‌سازی ماشین توسعه، بازرسی و تطبیق سورس واقعی، و تثبیت استانداردهای کد.

**تعداد زیربرنامه:** 100

1. نصب .NET 10 SDK — `dotnet --version`
2. نصب Node.js LTS برای ابزار فرانت — `node -v && npm -v`
3. نصب Flutter SDK پایدار — `flutter --version`
4. اجرای flutter doctor و رفع همهٔ هشدارها — `flutter doctor -v`
5. نصب Git و پیکربندی هویت — `git config --global user.name 'Ali'`
6. نصب IDE (Visual Studio/Rider/VS Code) و افزونه‌های C# و Flutter
7. نصب Docker Desktop برای DB و CI محلی — `docker --version`
8. نصب EF Core CLI Tools — `dotnet tool install --global dotnet-ef`
9. نصب dotnet-format برای قالب‌بندی — `dotnet tool install -g dotnet-format`
10. نصب dotnet-outdated برای پایش نسخه‌ها — `dotnet tool install -g dotnet-outdated-tool`
11. نصب trx2html/ReportGenerator برای گزارش تست — `dotnet tool install -g dotnet-reportgenerator-globaltool`
12. نصب httpie/curl برای تست API دستی — `curl --version`
13. باز کردن سورس D:\SourceKaravi\GitHub\Ntk.Note.IP در IDE
14. اجرای git status و ثبت شاخهٔ جاری — `git status`
15. اجرای git log برای فهم تاریخچهٔ اخیر — `git log --oneline -20`
16. فهرست پروژه‌های Solution — `dotnet sln list`
17. بررسی TargetFramework هر csproj (انتظار net10.0)
18. فهرست بسته‌های NuGet هر پروژه — `dotnet list package`
19. شناسایی لایه‌های موجود (Domain/Application/Infrastructure/Api/Web)
20. ساخت Cursor.02.plan.md و درج ساختار واقعی سورس (قاعدهٔ ۳/۴)
21. بررسی الگوهای کدنویسی فعلی پروژه (قاعدهٔ ۱۲/۲۸)
22. بررسی Conventionهای نام‌گذاری موجود و یادداشت مغایرت‌ها
23. بررسی وجود .editorconfig و تکمیل آن
24. بررسی/ایجاد Directory.Build.props مشترک
25. فعال‌سازی Central Package Management با Directory.Packages.props
26. فعال‌سازی Nullable و ImplicitUsings در props مشترک
27. فعال‌سازی TreatWarningsAsErrors در پیکربندی Release
28. افزودن آنالایزرها (Microsoft.CodeAnalysis.NetAnalyzers) — `dotnet add package`
29. افزودن StyleCop.Analyzers و فایل stylecop.json
30. افزودن Roslynator.Analyzers برای ریفکتور خودکار
31. تعریف قواعد نام‌گذاری در .editorconfig (PascalCase/camelCase)
32. ساخت فایل .gitignore مناسب .NET + Flutter + Node
33. ساخت فایل .gitattributes برای normalize کردن EOL
34. اجرای build کامل برای اطمینان از سلامت اولیه — `dotnet build`
35. اجرای restore و رفع تعارض نسخه‌ها — `dotnet restore`
36. ساخت README.md ریشه با معرفی پروژه (فارسی)
37. ساخت readmehistory.md و ثبت اولین رکورد با تاریخ/زمان (قاعدهٔ ۲۷)
38. ساخت پوشهٔ docs/ برای مستندات معماری
39. ساخت ADR اول (Architecture Decision Record): انتخاب API-First
40. ساخت ADR دوم: انتخاب دیتابیس (در Stage بعد قطعی می‌شود)
41. تعریف استراتژی شاخه‌بندی Git (trunk-based یا GitFlow سبک)
42. ساخت الگوی Pull Request در .github/
43. ساخت الگوی Issue (bug/feature) در .github/
44. تعریف Conventional Commits و ابزار commitlint
45. نصب pre-commit hook برای format+lint — `git config core.hooksPath .githooks`
46. ساخت اسکریپت build.ps1 و build.sh یکپارچه
47. ساخت Makefile برای دستورهای پرتکرار
48. تعریف متغیرهای محیطی موردنیاز در .env.example
49. افزودن مدیریت Secrets با User Secrets — `dotnet user-secrets init`
50. مستندسازی نحوهٔ تزریق Secrets در CI/Prod (Key Vault/ENV)
51. ساخت devcontainer.json برای محیط یکسان تیمی
52. ساخت docker-compose برای DB توسعه (Postgres/SqlServer)
53. ساخت سرویس Redis در docker-compose برای کش
54. ساخت سرویس Seq/OpenTelemetry Collector برای لاگ محلی
55. تعریف پورت‌ها و شبکهٔ داخلی compose
56. ساخت اسکریپت seed دیتابیس توسعه
57. بررسی سلامت اتصال به DB از طریق compose — `docker compose up -d`
58. تعریف نسخه‌بندی محصول (SemVer) و فایل version.json
59. ساخت CHANGELOG.md و قرارداد به‌روزرسانی آن
60. راه‌اندازی مخزن CI (GitHub Actions) با workflow پایه
61. افزودن job: dotnet restore/build در CI
62. افزودن job: اجرای تست‌ها در CI
63. افزودن job: انتشار گزارش پوشش تست (coverage)
64. افزودن job: flutter analyze + flutter test در CI
65. افزودن job: لینت فرانت‌اند وب در CI
66. افزودن کش وابستگی‌ها در CI برای سرعت
67. افزودن بررسی امنیتی وابستگی‌ها (dependabot/NuGet audit)
68. افزودن SAST سبک (CodeQL) در CI
69. تعریف Branch Protection روی main (نیاز به PR و سبزشدن CI)
70. ساخت محیط‌های Dev/Staging/Prod و فایل‌های appsettings.{Env}.json
71. تعریف ساختار لاگ ساخت‌یافته (Serilog) به‌صورت سراسری
72. تعریف correlation-id برای ردگیری درخواست‌ها
73. تعریف سیاست‌نامهٔ خطا و کدهای خطای استاندارد
74. ساخت فایل ترجمهٔ پایهٔ fa.json (زبان پایه)
75. ساخت فایل ترجمهٔ en.json هم‌تراز با fa.json
76. تعریف فرایند بررسی کامل‌بودن ترجمه‌ها (قاعدهٔ ۲۱/۲۲/۲۳)
77. ساخت اسکریپت بررسی کلیدهای ترجمهٔ گمشده میان fa/en
78. تعریف فونت فارسی پیش‌فرض (وزیرمتن/IRANSans) برای وب و اپ
79. تعریف جهت‌بندی RTL/LTR سراسری بر اساس زبان
80. تعریف پالت رنگ برند IPNote و توکن‌های رنگ
81. تعریف توکن‌های تم تاریک و روشن
82. تعریف تایپوگرافی و مقیاس فاصله‌گذاری (design tokens)
83. ساخت فایل design-tokens مشترک (وب + Flutter)
84. تعریف لوگو/فاوآیکون و دارایی‌های برند
85. تعریف استراتژی تست (هرم تست) و حداقل پوشش هدف
86. تعریف معیار Definition of Done برای هر تسک
87. تعریف بک‌لاگ بر اساس ۱۴۷ امکان کاتالوگ
88. اولویت‌بندی امکانات به MVP / v1 / Future
89. نگاشت هر امکان به Stage مربوط در همین پلن
90. تعریف KPIها (Core Web Vitals، زمان پاسخ API)
91. تعریف بودجهٔ کارایی (performance budget) اولیه
92. تعریف سیاست حریم خصوصی و نگه‌داری داده (data retention)
93. بررسی الزامات قانونی GDPR برای تاریخچهٔ IP
94. تعریف سیاست رضایت کاربر برای ذخیرهٔ تاریخچه
95. ساخت برد وظایف (Project Board) و انتقال بک‌لاگ
96. تعریف جلسات بازبینی پلن و چرخهٔ به‌روزرسانی plan files
97. تأیید نهایی محیط با اجرای کامل build+test+analyze
98. ثبت رکورد پایان Stage 0 در readmehistory با تاریخ/زمان
99. تعریف الگوی نام‌گذاری شاخه‌ها (feature/*, fix/*, release/*)
100. تدوین چک‌لیست بازبینی کد (Code Review Checklist) تیمی

**Result 1 (معیار پایان):** همهٔ ابزارها نصب و سالم‌اند، ساختار فعلی سورس مستند شده، و کنوانسیون‌ها/CI پایه فعال است.

---

## Part 2 — اسکلت Solution و معماری بک‌اند (.NET 10 Clean Architecture) (`S1`)

**هدف:** ساخت/تطبیق ساختار لایه‌ای پروژه، وابستگی‌های بین‌لایه‌ای و زیرساخت مشترک.

**تعداد زیربرنامه:** 100

1. ساخت Solution در صورت نبود — `dotnet new sln -n Ntk.Note.IP`
2. ساخت پروژهٔ Domain — `dotnet new classlib -n Ntk.Note.IP.Domain`
3. ساخت پروژهٔ Application — `dotnet new classlib -n Ntk.Note.IP.Application`
4. ساخت پروژهٔ Infrastructure — `dotnet new classlib -n Ntk.Note.IP.Infrastructure`
5. ساخت پروژهٔ Shared/Contracts — `dotnet new classlib -n Ntk.Note.IP.Shared`
6. ساخت پروژهٔ Api — `dotnet new webapi -n Ntk.Note.IP.Api`
7. افزودن همهٔ پروژه‌ها به Solution — `dotnet sln add **/*.csproj`
8. تعریف وابستگی Application → Domain — `dotnet add reference`
9. تعریف وابستگی Infrastructure → Application,Domain
10. تعریف وابستگی Api → Application,Infrastructure,Shared
11. ممنوع‌سازی وابستگی Domain به لایه‌های بیرونی (بررسی با ArchUnitNET)
12. افزودن تست معماری ArchUnitNET برای مرزبندی لایه‌ها
13. تنظیم net10.0 و Nullable در همهٔ csproj
14. ساخت ساختار پوشه‌ای استاندارد هر لایه
15. تعریف الگوی Result/Either برای خروجی عملیات (به‌جای throw)
16. ساخت کلاس پایهٔ Error و ErrorCodes
17. تعریف الگوی Pagination مشترک (PagedResult<T>)
18. تعریف الگوی Ardalis.Specification برای کوئری‌ها — `dotnet add package`
19. افزودن MediatR برای CQRS در Application — `dotnet add package MediatR`
20. افزودن FluentValidation — `dotnet add package FluentValidation`
21. افزودن Mapster/AutoMapper برای نگاشت DTO
22. تعریف PipelineBehavior لاگ‌گیری در MediatR
23. تعریف PipelineBehavior اعتبارسنجی در MediatR
24. تعریف PipelineBehavior مدیریت خطا/تراکنش
25. تعریف PipelineBehavior کش‌گذاری کوئری‌ها
26. ساخت IDateTime/IClock برای تست‌پذیری زمان
27. ساخت ICurrentUser برای دسترسی به کاربر جاری
28. تنظیم تزریق وابستگی Application (AddApplication extension)
29. تنظیم تزریق وابستگی Infrastructure (AddInfrastructure extension)
30. تنظیم Options Pattern برای پیکربندی‌ها
31. اعتبارسنجی پیکربندی هنگام Startup (ValidateOnStart)
32. راه‌اندازی Serilog با سینک Console+File+Seq
33. افزودن enrichers (correlation-id, request-path) به لاگ
34. افزودن OpenTelemetry Tracing/Metrics — `dotnet add package`
35. افزودن HealthChecks برای DB/Redis/External APIs
36. تعریف endpoint سلامت /health و /health/ready
37. تعریف میدلور مدیریت خطای سراسری (ProblemDetails)
38. تعریف میدلور ثبت زمان پاسخ و متریک
39. پیکربندی JSON (camelCase, enum as string)
40. پیکربندی فرهنگ/Localization سراسری (fa پیش‌فرض)
41. ساخت ساختار Shared برای DTOهای قرارداد API
42. تعریف نسخه‌بندی API (Asp.Versioning) — `dotnet add package`
43. افزودن Swashbuckle/OpenAPI و UI — `dotnet add package Swashbuckle.AspNetCore`
44. تنظیم تولید فایل openapi.json در build
45. تعریف سیاست CORS برای دامنهٔ وب و اپ
46. افزودن Rate Limiting داخلی .NET
47. افزودن Response Compression (gzip/brotli)
48. افزودن Output Caching برای پاسخ‌های عمومی IP
49. تعریف میدلور استخراج IP واقعی (ForwardedHeaders)
50. پیکربندی صحیح KnownProxies/KnownNetworks (پشت CDN)
51. ساخت سرویس IIpExtractor برای استخراج IP کلاینت
52. ساخت سرویس IUserAgentParser برای تجزیهٔ UA
53. تعریف قراردادهای Endpoint (Minimal API grouping)
54. ساخت کلاس پایهٔ EndpointGroup و الگوی ثبت
55. تعریف استاندارد پاسخ API (envelope/ProblemDetails)
56. ساخت آزمون دود (smoke test) برای بالا آمدن Api
57. تعریف اسکریپت اجرای محلی Api — `dotnet run --project Ntk.Note.IP.Api`
58. تعریف launchSettings برای محیط توسعه
59. تعریف فایل http. (REST Client) برای تست دستی endpointها
60. افزودن Scalar/Swagger UI با تم و توضیح فارسی
61. تعریف ساختار ماژولار برای افزودن Featureها
62. ساخت قالب (template) افزودن یک Feature جدید (Command+Handler+Endpoint+Test)
63. مستندسازی الگوی Vertical Slice برای Featureها
64. تعریف سیاست لاگ‌نکردن داده‌های حساس (PII redaction)
65. افزودن ProblemDetails سفارشی با traceId
66. تعریف کدهای وضعیت HTTP استاندارد پروژه
67. افزودن Idempotency-Key برای عملیات نوشتنی حساس
68. تعریف الگوی Soft Delete در Domain/Infra
69. تعریف الگوی Audit (CreatedBy/At, ModifiedBy/At)
70. تعریف interfaceهای Repository در Application
71. تعریف IUnitOfWork در Application
72. تعریف رخدادهای دامنه (Domain Events) و Dispatcher
73. تعریف Outbox Pattern برای رخدادها (پایه)
74. تعریف الگوی BackgroundJob (Hangfire/Quartz) — انتخاب در Infra
75. تعریف صف کار برای پایش تغییر IP
76. ساخت تنظیمات feature flags (پایه)
77. افزودن Polly برای Retry/Circuit Breaker روی APIهای بیرونی
78. تعریف HttpClientFactory نام‌دار برای هر Provider بیرونی
79. تعریف Timeout و Backoff استاندارد HttpClientها
80. افزودن Caching دو لایه (Memory + Redis)
81. تعریف کلید کش استاندارد و TTL برای دادهٔ IP
82. تعریف سیاست نامعتبرسازی کش (cache invalidation)
83. افزودن متریک Prometheus endpoint
84. تعریف داشبورد پایش (Grafana) — اختیاری
85. افزودن Feature Folder ساختار برای IP/Geo/History/Account
86. تعریف قرارداد خطای محلی‌شده (پیام خطای فارسی/انگلیسی)
87. تعریف منبع پیام‌ها (Resource files) برای خطاها
88. بررسی build کامل بک‌اند بدون warning — `dotnet build -warnaserror`
89. اجرای تحلیل استاتیک و رفع هشدارها — `dotnet format --verify-no-changes`
90. نوشتن تست واحد برای Behaviorهای MediatR
91. نوشتن تست برای میدلور خطا و خروجی ProblemDetails
92. نوشتن تست برای IpExtractor با هدرهای مختلف
93. نوشتن تست معماری (لایه‌ها به هم نشت نکنند)
94. مستندسازی نمودار وابستگی لایه‌ها در docs/
95. ساخت دیاگرام C4 سطح Container در docs/
96. بازبینی کد اسکلت و انطباق با کنوانسیون‌ها
97. ثبت ADR انتخاب CQRS/MediatR و دلایل
98. ثبت رکورد پایان Stage 1 در readmehistory با تاریخ/زمان
99. تعریف نقطهٔ واحد نگاشت خطای دامنه به HTTP (Exception→ProblemDetails)
100. افزودن پروژهٔ Benchmark (BenchmarkDotNet) برای مسیرهای داغ

**Result 2 (معیار پایان):** Solution با لایه‌های جداگانه، مرزبندی صحیح وابستگی، و سرویس‌های مشترک (DI/Logging/Config) build می‌شود.

---

## Part 3 — لایهٔ Domain — موجودیت‌ها و قواعد کسب‌وکار IP (`S2`)

**هدف:** مدل‌سازی دامنهٔ IP، تاریخچه، یادداشت، کاربر و قواعد ذاتی بدون وابستگی بیرونی.

**تعداد زیربرنامه:** 100

1. تعریف Entity پایه (BaseEntity با Id/Audit)
2. تعریف AggregateRoot و الگوی Domain Events
3. تعریف ValueObject پایه با مقایسهٔ مقداری
4. ساخت VO به نام IpAddress با اعتبارسنجی v4/v6
5. متد تشخیص نوع IP (Public/Private/CGNAT/Reserved) در VO
6. متد تبدیل IP به Integer و بالعکس
7. متد فرمت فشرده/کامل IPv6
8. ساخت VO به نام Cidr/Subnet و محاسبهٔ رنج
9. محاسبهٔ تعداد هاست‌های قابل‌استفاده در Subnet
10. ساخت VO به نام GeoLocation (lat/lng/country/region/city)
11. اعتبارسنجی مختصات جغرافیایی در VO
12. ساخت VO به نام Asn (number/org/domain/type)
13. ساخت VO به نام Coordinates و فاصلهٔ Haversine
14. ساخت VO به نام Timezone و ساعت محلی
15. ساخت VO به نام DeviceInfo (os/browser/deviceType/model)
16. ساخت Enum برای DeviceType (Desktop/Mobile/Tablet/Bot)
17. ساخت Enum برای ConnectionType (Wifi/Cellular/Ethernet/Unknown)
18. ساخت Enum برای NetworkType (Residential/Hosting/Mobile/Business)
19. ساخت VO به نام UserAgent با تجزیهٔ ساخت‌یافته
20. ساخت Entity به نام IpRecord (یک مشاهدهٔ IP)
21. افزودن فیلدهای موقعیت/شبکه/دستگاه/زمان به IpRecord
22. افزودن رابطهٔ IpRecord به User (اختیاری برای مهمان)
23. افزودن فیلد یادداشت (Note) و Tagها به IpRecord
24. ساخت Entity به نام IpNote (یادداشت مستقل قابل‌ویرایش)
25. ساخت Entity به نام Tag و رابطهٔ چند‌به‌چند
26. ساخت Aggregate به نام IpHistory برای یک کاربر
27. قاعدهٔ افزودن مشاهدهٔ جدید فقط در صورت تغییر IP/شبکه
28. قاعدهٔ تشخیص 'اتصال جدید' و تولید رخداد NewConnectionDetected
29. رخداد دامنه IpChangedEvent با مقادیر قبل/بعد
30. قاعدهٔ ادغام تاریخچهٔ مهمان با کاربر هنگام لاگین
31. قاعدهٔ حذف نرم (Soft Delete) رکوردهای تاریخچه
32. قاعدهٔ سقف نگه‌داری رکورد برای کاربر مهمان
33. ساخت Entity به نام User (هویت دامنه‌ای، جدا از Identity)
34. افزودن پروفایل و تنظیمات حریم خصوصی به User
35. افزودن ترجیح زبان و تم به User
36. ساخت Entity به نام ApiKey برای دسترسی توسعه‌دهنده
37. قاعدهٔ تولید/ابطال ApiKey و محدودهٔ دسترسی
38. ساخت Entity به نام Alert (هشدار تغییر IP/بلک‌لیست)
39. ساخت Enum برای AlertChannel (Email/Push/Webhook)
40. ساخت VO به نام BlacklistResult (لیست‌ها و وضعیت)
41. ساخت VO به نام ReputationScore با بازهٔ معتبر
42. ساخت VO به نام PrivacyFlags (vpn/proxy/tor/relay)
43. ساخت VO به نام DnsRecordSet (A/AAAA/MX/TXT/NS)
44. ساخت VO به نام WhoisInfo (range/org/allocationDate)
45. ساخت Entity به نام LookupQuery برای ثبت لوک‌آپ‌های کاربر
46. قاعدهٔ محدودسازی نرخ لوک‌آپ برای مهمان
47. ساخت VO به نام PortCheckResult (port/state/service)
48. ساخت VO به نام PingResult (rtt/loss)
49. ساخت VO به نام TracerouteHop (index/ip/rtt/asn)
50. ساخت VO به نام SpeedTestResult (down/up/ping/jitter)
51. ساخت VO به نام Fingerprint (canvas/webgl/audio hashes)
52. قاعدهٔ محاسبهٔ درصد یکتایی اثرانگشت (در Application اما قرارداد در Domain)
53. ساخت VO به نام SslCertificateInfo (issuer/expiry/chain)
54. تعریف interface قراردادی IGeoLocationProvider (در Application)
55. تعریف interface قراردادی IAsnProvider
56. تعریف interface قراردادی IBlacklistProvider
57. تعریف interface قراردادی IReputationProvider
58. تعریف interface قراردادی IDnsLookupService
59. تعریف interface قراردادی IPingService/ITracerouteService
60. تعریف interface قراردادی IGeoIpDatabase (آفلاین MMDB)
61. تعریف قواعد اعتبارسنجی نام دامنه (برای lookup)
62. تعریف قواعد اعتبارسنجی Tag (طول/کاراکتر مجاز)
63. تعریف قواعد اعتبارسنجی Note (حداکثر طول)
64. تعریف Exceptionهای دامنه‌ای معنادار
65. تعریف Guard Clauses مشترک (Ardalis.GuardClauses)
66. نوشتن تست واحد IpAddress برای v4 معتبر/نامعتبر
67. نوشتن تست واحد IpAddress برای v6 و فرمت‌ها
68. نوشتن تست تشخیص Public/Private/CGNAT
69. نوشتن تست تبدیل IP↔Integer
70. نوشتن تست محاسبهٔ Subnet و تعداد هاست
71. نوشتن تست GeoLocation و فاصلهٔ Haversine
72. نوشتن تست قاعدهٔ تشخیص اتصال جدید
73. نوشتن تست رخداد IpChangedEvent
74. نوشتن تست ادغام تاریخچهٔ مهمان با کاربر
75. نوشتن تست Soft Delete و سقف نگه‌داری
76. نوشتن تست تولید/ابطال ApiKey
77. نوشتن تست اعتبارسنجی Tag/Note
78. نوشتن تست ReputationScore خارج از بازه
79. نوشتن تست PrivacyFlags و ترکیب وضعیت‌ها
80. نوشتن تست TracerouteHop و ترتیب hopها
81. پوشش تست دامنه حداقل ۹۰٪ (هدف)
82. افزودن داده‌های نمونه (ObjectMother/Builder) برای تست
83. بازبینی نام‌گذاری همهٔ موجودیت‌ها طبق PascalCase
84. بازبینی عدم نشت وابستگی بیرونی در Domain
85. بازبینی Immutability ولیو‌آبجکت‌ها
86. مستندسازی نمودار دامنه (Domain Model) در docs/
87. مستندسازی واژه‌نامهٔ Ubiquitous Language (فارسی/انگلیسی)
88. بازبینی رخدادهای دامنه و مصرف‌کنندگان آینده
89. تعریف نگاشت امکانات کاتالوگ (انواع IP/موقعیت) به موجودیت‌ها
90. تعریف نگاشت امکانات تاریخچه/یادداشت به Aggregateها
91. بررسی سازگاری مدل با نیاز Flutter (سریال‌پذیری)
92. بررسی سازگاری مدل با خروجی API (DTO mapping)
93. افزودن XML-doc فارسی روی APIهای عمومی دامنه
94. اجرای کامل تست‌های دامنه — `dotnet test`
95. رفع هرگونه هشدار آنالایزر در Domain
96. بازبینی نهایی Stage 2 و چک‌لیست DoD
97. ثبت ADR مدل‌سازی IP به‌صورت Value Object
98. ثبت رکورد پایان Stage 2 در readmehistory با تاریخ/زمان
99. تعریف قاعدهٔ یکتایی Tag در سطح هر کاربر
100. تعریف invariantهای Aggregate و تست نقض آن‌ها

**Result 3 (معیار پایان):** موجودیت‌ها، Value Objectها، قواعد و رخدادهای دامنه با تست واحد کامل پوشش داده شده‌اند.

---

## Part 4 — لایهٔ Application — CQRS، Handlerها، اعتبارسنجی و DTO (`S3`)

**هدف:** پیاده‌سازی منطق کاربردی همهٔ امکانات به‌صورت Command/Query با اعتبارسنجی و نگاشت.

**تعداد زیربرنامه:** 100

1. تعریف ساختار Feature-folder در Application (IP/Geo/Network/History/Account/Tools)
2. Query: GetMyIp (استخراج IP کلاینت و نوع آن)
3. Query: GetIpDetails (موقعیت+ASN+شبکه برای IP دلخواه)
4. Query: GetGeoLocation برای IP
5. Query: GetAsnInfo برای IP
6. Query: GetReverseDns (PTR)
7. Query: GetWhoisIp
8. Query: GetWhoisDomain
9. Query: ResolveDns (A/AAAA/MX/TXT/NS/CNAME/SOA)
10. Query: CheckDnsPropagation روی چند resolver
11. Query: CheckBlacklist (DNSBL چندگانه)
12. Query: GetReputationScore
13. Query: DetectVpnProxyTor (PrivacyFlags)
14. Query: GetSslCertificateInfo برای دامنه
15. Query: CheckPort (پورت دلخواه روی هاست)
16. Query: CheckCommonPorts
17. Command: RunPing (async/job)
18. Command: RunTraceroute (async/job)
19. Command: RunSpeedTest (هماهنگی با probe)
20. Query: CalculateSubnet (CIDR calculator)
21. Query: ConvertIp (ip↔int، فشرده/کامل)
22. Query: GetTimezoneClock برای IP
23. Command: RecordIpObservation (ثبت مشاهدهٔ جدید)
24. منطق تشخیص تغییر و عدم‌ثبت تکراری در RecordIpObservation
25. Query: GetBrowserHistory (برای مهمان — قرارداد همگام با localStorage)
26. Query: GetUserHistory (تاریخچهٔ کاربر لاگین‌کرده، صفحه‌بندی)
27. Query: GetHistoryByFilter (تاریخ/کشور/دستگاه/تگ)
28. Query: GetHistoryTimeline
29. Query: GetHistoryStats (تعداد یکتا/کشورها/دستگاه‌ها)
30. Query: GetHistoryMapPoints (نقشهٔ تجمعی)
31. Command: AddNoteToRecord
32. Command: UpdateNote
33. Command: DeleteNote (soft)
34. Command: AddTag / RemoveTag
35. Command: MergeGuestHistory (هنگام لاگین)
36. Command: DeleteHistory (انتخابی/کامل با تأیید)
37. Command: ExportHistory (CSV/JSON)
38. Query: DiffTwoConnections (مقایسهٔ دو اتصال)
39. Command: CreateAlert (تغییر IP/بلک‌لیست)
40. Command: UpdateAlert / DeleteAlert
41. Query: ListAlerts
42. Command: CreateApiKey / RevokeApiKey
43. Query: ListApiKeys
44. Command: RegisterUser (قرارداد با Identity)
45. Command: LoginUser (صدور توکن)
46. Command: RefreshToken
47. Command: Enable2FA / Verify2FA
48. Command: UpdateProfile / UpdatePrivacySettings
49. Command: ChangeLanguage / ChangeTheme
50. Command: DeleteAccount (با خروجی کامل داده)
51. Query: ExportPersonalData (GDPR)
52. Query: GetUserAgentInfo (تجزیهٔ UA)
53. Query: SummarizeBulkIps (لوک‌آپ گروهی)
54. Command: SaveFingerprint (ثبت اثرانگشت ارسالی کلاینت)
55. Query: GetFingerprintUniqueness (محاسبهٔ درصد یکتایی)
56. Query: GetPrivacyScore (تجمیع نتایج تست‌ها)
57. Query: GetCommandSnippets (Linux/Mac/Win/PS/MikroTik/C#/JS)
58. تعریف DTOهای ورودی/خروجی هر Query/Command
59. تعریف Validator برای هر Command/Query (FluentValidation)
60. اعتبارسنجی فرمت IP/دامنه/CIDR در Validatorها
61. اعتبارسنجی محدودیت نرخ مهمان در Handlerها
62. نگاشت Domain↔DTO با Mapster (پروفایل‌ها)
63. تعریف Caching attribute روی Queryهای IP/Geo/ASN
64. تعریف کلید کش و TTL مناسب هر Query
65. تعریف Behavior تراکنش برای Commandهای نوشتنی
66. تعریف Behavior لاگ‌گیری ورودی/خروجی (بدون PII)
67. تعریف Behavior سنجش زمان اجرا (performance)
68. مدیریت رخداد IpChangedEvent → صف هشدار
69. مدیریت رخداد NewConnectionDetected → ثبت تاریخچه
70. تعریف سرویس IIpEnrichmentService (تجمیع چند Provider)
71. تعریف استراتژی Fallback میان Providerها (مطابق الگوی asn)
72. تعریف سیاست ادغام دادهٔ آفلاین MMDB با APIهای آنلاین
73. تعریف نرمال‌سازی خروجی موقعیت (یکدست‌سازی فیلدها)
74. تعریف محلی‌سازی نام کشور/شهر (fa/en)
75. تعریف خطاهای کاربردی محلی‌شده
76. نوشتن تست واحد GetMyIp با هدرهای پراکسی
77. نوشتن تست GetIpDetails با Provider جعلی (mock)
78. نوشتن تست RecordIpObservation (عدم‌ثبت تکراری)
79. نوشتن تست MergeGuestHistory
80. نوشتن تست DiffTwoConnections
81. نوشتن تست CheckBlacklist با چند لیست
82. نوشتن تست CalculateSubnet مرزی
83. نوشتن تست Validatorها (ورودی نامعتبر)
84. نوشتن تست Caching Behavior (hit/miss)
85. نوشتن تست Fallback میان Providerها
86. نوشتن تست ExportHistory (CSV/JSON صحیح)
87. نوشتن تست محاسبهٔ PrivacyScore
88. نوشتن تست محلی‌سازی پیام‌های خطا
89. پوشش تست Application حداقل ۸۵٪ (هدف)
90. افزودن mockهای Provider بیرونی برای تست
91. بازبینی عدم وجود وابستگی Infra در Application
92. بازبینی الگوی یکدست خطا/نتیجه در همهٔ Handlerها
93. مستندسازی فهرست use-caseها و نگاشت به امکانات کاتالوگ
94. مستندسازی قرارداد رویدادها و مصرف‌کنندگان
95. بازبینی نام‌گذاری Command/Query طبق کنوانسیون
96. بررسی سازگاری DTOها با OpenAPI و Flutter
97. اجرای کامل تست‌های Application — `dotnet test`
98. رفع هشدارهای آنالایزر در Application
99. بازبینی نهایی Stage 3 و چک‌لیست DoD
100. ثبت رکورد پایان Stage 3 در readmehistory با تاریخ/زمان

**Result 4 (معیار پایان):** همهٔ use-caseهای امکانات کاتالوگ به‌صورت Handler با تست واحد آماده‌اند؛ منطق در کنترلر نیست.

---

## Part 5 — لایهٔ Infrastructure — دیتابیس، Providerهای بیرونی، کش و Jobها (`S4`)

**هدف:** پیاده‌سازی پایداری داده با EF Core و یکپارچه‌سازی سرویس‌های بیرونی IP/Geo/ASN و زیرساخت اجرایی.

**تعداد زیربرنامه:** 100

1. قطعی‌سازی انتخاب دیتابیس (PostgreSQL پیشنهادی) و ثبت ADR
2. افزودن EF Core و Provider DB — `dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL`
3. ساخت AppDbContext و DbSetها
4. پیکربندی نگاشت IpRecord با EntityTypeConfiguration
5. پیکربندی نگاشت User/Note/Tag/Alert/ApiKey/LookupQuery
6. پیکربندی ValueObjectها به‌صورت Owned Types
7. ذخیرهٔ IpAddress به‌صورت inet/متن بهینه
8. تعریف ایندکس روی (UserId, ObservedAt) برای تاریخچه
9. تعریف ایندکس روی Ip برای جستجوی سریع
10. تعریف کوئری فیلتر سراسری Soft Delete
11. پیاده‌سازی Audit خودکار در SaveChanges
12. پیاده‌سازی Outbox برای Domain Events
13. پیاده‌سازی IUnitOfWork روی DbContext
14. پیاده‌سازی Repositoryهای موردنیاز (Specification)
15. ساخت اولین Migration — `dotnet ef migrations add Init`
16. اعمال Migration روی DB توسعه — `dotnet ef database update`
17. تعریف استراتژی Migration در CI/Prod (idempotent script)
18. ساخت Seeder دادهٔ اولیه (تگ‌های پیش‌فرض، ادمین)
19. تنظیم اتصال‌رشته‌ها از Secrets/ENV
20. تنظیم Resilience اتصال DB (EnableRetryOnFailure)
21. پیاده‌سازی IGeoIpDatabase با MaxMind/IPinfo MMDB آفلاین
22. اسکریپت به‌روزرسانی روزانهٔ پایگاه MMDB
23. پیاده‌سازی IGeoLocationProvider با ip-api (fallback)
24. پیاده‌سازی IGeoLocationProvider با ipinfo (اصلی)
25. پیاده‌سازی IAsnProvider (ASN/Org/Type)
26. پیاده‌سازی IReputationProvider (StopForumSpam/IPQS)
27. پیاده‌سازی IBlacklistProvider (کوئری DNSBL واقعی)
28. پیاده‌سازی IDnsLookupService (A/AAAA/MX/TXT/NS)
29. پیاده‌سازی DNSSEC validation
30. پیاده‌سازی WhoisClient (IP و دامنه)
31. پیاده‌سازی ReverseDns (PTR)
32. پیاده‌سازی SslInspector (گواهی/زنجیره/انقضا)
33. پیاده‌سازی PortChecker (TCP connect با timeout)
34. پیاده‌سازی IPingService (ICMP/probe)
35. پیاده‌سازی ITracerouteService (با شناسایی ASN/IXP)
36. یکپارچه‌سازی SpeedTest probe/endpoint
37. پیاده‌سازی IUserAgentParser (UAParser)
38. پیکربندی HttpClientFactory نام‌دار هر Provider
39. افزودن Polly Retry/CircuitBreaker/Timeout هر Provider
40. افزودن کش Redis برای پاسخ Providerها — `dotnet add package StackExchange.Redis`
41. پیاده‌سازی ICacheService دو لایه (Memory+Redis)
42. تعریف کلید/TTL و نامعتبرسازی کش
43. پیاده‌سازی IEmailSender (SMTP/Provider) برای هشدار/۲FA
44. پیاده‌سازی IPushSender (FCM/APNs) برای اپ
45. پیاده‌سازی IWebhookSender برای هشدار توسعه‌دهنده
46. انتخاب و راه‌اندازی BackgroundJobs (Hangfire) — `dotnet add package Hangfire`
47. Job: پایش دوره‌ای تغییر IP کاربران مشترک
48. Job: به‌روزرسانی پایگاه MMDB
49. Job: پاک‌سازی تاریخچهٔ مهمان منقضی
50. Job: ارسال هشدارهای صف‌شده
51. Job: پردازش Outbox و انتشار رویدادها
52. پیکربندی داشبورد Hangfire با احراز هویت
53. پیاده‌سازی IDateTime/IClock واقعی
54. پیاده‌سازی ICurrentUser از HttpContext
55. پیاده‌سازی IIpExtractor با ForwardedHeaders
56. پیکربندی AddInfrastructure (ثبت همهٔ سرویس‌ها در DI)
57. افزودن HealthCheck برای DB/Redis/Providerهای حیاتی
58. افزودن متریک برای نرخ موفقیت/خطای Providerها
59. افزودن لاگ ساخت‌یافته برای هر فراخوانی بیرونی
60. محدودسازی نرخ فراخوانی APIهای بیرونی (rate limit داخلی)
61. مدیریت سهمیهٔ رایگان APIها و سوییچ به آفلاین
62. رمزنگاری دادهٔ حساس در DB (در صورت نیاز)
63. هش‌کردن ApiKey و عدم ذخیرهٔ متن خام
64. پیاده‌سازی ذخیرهٔ Refresh Token امن
65. نوشتن تست یکپارچه با Testcontainers (Postgres) — `dotnet add package Testcontainers`
66. نوشتن تست یکپارچه Repository/UnitOfWork
67. نوشتن تست Migration و اعمال روی DB موقت
68. نوشتن تست Provider با سرور HTTP جعلی (WireMock)
69. نوشتن تست Polly (شکست و بازیابی)
70. نوشتن تست کش (hit/miss/invalidation)
71. نوشتن تست Job پایش تغییر IP
72. نوشتن تست Outbox و انتشار رویداد
73. نوشتن تست BlacklistProvider با پاسخ‌های نمونه
74. نوشتن تست DnsLookup با رکوردهای نمونه
75. نوشتن تست PortChecker (باز/بسته/timeout)
76. نوشتن تست Whois parsing
77. نوشتن تست SslInspector (گواهی منقضی)
78. بنچمارک کوئری‌های تاریخچهٔ بزرگ
79. بهینه‌سازی ایندکس‌ها بر اساس پلن کوئری
80. افزودن صفحه‌بندی Keyset برای تاریخچهٔ بزرگ
81. تعریف سیاست بکاپ DB و بازیابی
82. تعریف اسکریپت مهاجرت بدون توقف (zero-downtime)
83. بررسی نشت اتصال (connection leak) و Dispose صحیح
84. بررسی امنیت تزریق SQL (پارامتری‌بودن کوئری‌ها)
85. بررسی ماسک‌کردن PII در لاگ Providerها
86. مستندسازی Providerها و کلید/سهمیهٔ موردنیاز
87. مستندسازی مدل داده و دیاگرام ER در docs/
88. مستندسازی Jobها و زمان‌بندی آن‌ها
89. بازبینی AddInfrastructure و صحت طول عمر سرویس‌ها (lifetime)
90. بازبینی fallbackها و رفتار در قطعی Provider
91. اجرای کامل تست‌های Infrastructure — `dotnet test`
92. رفع هشدارهای آنالایزر در Infrastructure
93. اجرای تحلیل کارایی و رفع گلوگاه‌ها
94. بازبینی نهایی Stage 4 و چک‌لیست DoD
95. ثبت ADR انتخاب دیتابیس و Providerها
96. ثبت رکورد پایان Stage 4 در readmehistory با تاریخ/زمان
97. افزودن ایندکس GIN/Trigram برای جستجوی متن یادداشت
98. طراحی partitioning زمانی جدول تاریخچه برای مقیاس
99. تعریف مسیر read-replica برای کوئری‌های سنگین گزارشی
100. تست همروندی و قفل خوش‌بینانه (RowVersion/Concurrency token)

**Result 5 (معیار پایان):** دیتابیس مهاجرت‌پذیر، Providerها با Retry/Cache، و Jobهای پس‌زمینه عملیاتی و تست‌شده‌اند.

---

## Part 6 — لایهٔ API — Endpointها، احراز هویت، OpenAPI و امنیت (`S5`)

**هدف:** بیرونی‌کردن همهٔ use-caseها به‌صورت API امن، نسخه‌دار و مستند برای وب و Flutter.

**تعداد زیربرنامه:** 100

1. ساخت گروه Endpoint برای IP (/api/v1/ip/*)
2. Endpoint: GET /ip/me (IP من + نوع)
3. Endpoint: GET /ip/me/plain (خروجی متنی خام برای curl)
4. Endpoint: GET /ip/{ip} (جزئیات IP دلخواه)
5. Endpoint: GET /ip/{ip}/geo
6. Endpoint: GET /ip/{ip}/asn
7. Endpoint: GET /ip/{ip}/reverse-dns
8. Endpoint: GET /ip/{ip}/whois
9. Endpoint: GET /domain/{name}/whois
10. Endpoint: GET /dns/resolve
11. Endpoint: GET /dns/propagation
12. Endpoint: GET /ip/{ip}/blacklist
13. Endpoint: GET /ip/{ip}/reputation
14. Endpoint: GET /ip/{ip}/privacy (vpn/proxy/tor)
15. Endpoint: GET /ssl/inspect
16. Endpoint: GET /port/check
17. Endpoint: POST /tools/ping
18. Endpoint: POST /tools/traceroute
19. Endpoint: POST /tools/speedtest
20. Endpoint: GET /tools/subnet
21. Endpoint: GET /tools/convert
22. Endpoint: POST /ip/observe (ثبت مشاهده)
23. Endpoint: GET /history (کاربر، صفحه‌بندی/فیلتر)
24. Endpoint: GET /history/timeline
25. Endpoint: GET /history/stats
26. Endpoint: GET /history/map
27. Endpoint: GET /history/export (CSV/JSON)
28. Endpoint: POST /history/merge-guest
29. Endpoint: DELETE /history (انتخابی/کامل)
30. Endpoint: POST /records/{id}/note
31. Endpoint: PUT /notes/{id} / DELETE /notes/{id}
32. Endpoint: POST /records/{id}/tags / DELETE
33. Endpoint: GET /history/diff
34. Endpoint: CRUD /alerts
35. Endpoint: CRUD /api-keys
36. Endpoint: GET /ua/parse
37. Endpoint: POST /bulk/summarize
38. Endpoint: POST /fingerprint
39. Endpoint: GET /privacy-score
40. Endpoint: GET /commands (اسنیپت‌های دستور)
41. Endpoint: Auth register/login/refresh/2fa
42. Endpoint: profile/settings/language/theme
43. Endpoint: DELETE /account + GET /account/export (GDPR)
44. تعریف نگاشت همهٔ endpointها به Query/Command (بدون منطق در کنترلر)
45. افزودن ASP.NET Core Identity و جداول کاربر — `dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore`
46. پیکربندی احراز هویت Cookie برای وب
47. پیکربندی JWT Bearer برای اپ Flutter و API
48. پیاده‌سازی Refresh Token و چرخش امن
49. پیاده‌سازی 2FA (TOTP) و کدهای بازیابی
50. پیکربندی OAuth (Google/GitHub) برای ورود
51. پیاده‌سازی احراز هویت ApiKey برای endpointهای توسعه‌دهنده
52. تعریف Policyها و Roleها (User/Admin)
53. تعریف Authorization در سطح endpoint
54. افزودن Rate Limiting per-IP و per-ApiKey
55. تعریف سهمیهٔ متفاوت مهمان/کاربر/توسعه‌دهنده
56. افزودن CORS دقیق برای دامنهٔ وب و scheme اپ
57. افزودن هدرهای امنیتی (HSTS/CSP/XFO/Referrer-Policy)
58. افزودن Anti-Forgery برای فرم‌های وب (در صورت Cookie)
59. افزودن ProblemDetails یکدست برای همهٔ خطاها
60. محلی‌سازی پیام خطای پاسخ (fa/en) بر اساس Accept-Language
61. افزودن نسخه‌بندی API (v1) و سیاست منسوخ‌سازی
62. افزودن OpenAPI کامل با توضیح فارسی هر endpoint
63. افزودن نمونهٔ درخواست/پاسخ به OpenAPI
64. افزودن schema امنیتی (Bearer/ApiKey) به OpenAPI
65. تولید خودکار openapi.json در پایپ‌لاین
66. افزودن Swagger/Scalar UI با احراز هویت در Prod
67. افزودن Idempotency-Key روی POSTهای حساس
68. افزودن ETag/Cache-Control برای پاسخ‌های IP عمومی
69. افزودن Output Caching برای /ip/{ip}
70. افزودن Compression پاسخ‌ها
71. افزودن Correlation-Id به همهٔ پاسخ‌ها
72. افزودن لاگ دسترسی بدون ثبت PII
73. افزودن متریک per-endpoint (latency/error rate)
74. افزودن HealthCheck endpointها به مانیتورینگ
75. افزودن محدودیت اندازهٔ بدنهٔ درخواست
76. افزودن اعتبارسنجی ورودی در مرز API (mirror Validator)
77. افزودن webhook delivery برای هشدار توسعه‌دهنده
78. افزودن SSE/WebSocket برای نتایج بلادرنگ ping/traceroute
79. نوشتن تست عملکردی (WebApplicationFactory) برای /ip/me
80. نوشتن تست احراز هویت (login→protected endpoint)
81. نوشتن تست JWT/Refresh/2FA
82. نوشتن تست Rate Limiting (عبور از سقف)
83. نوشتن تست Authorization (User vs Admin)
84. نوشتن تست محلی‌سازی خطا بر اساس Accept-Language
85. نوشتن تست خروجی plain برای curl
86. نوشتن تست export تاریخچه از طریق API
87. نوشتن تست قرارداد (contract) مطابق OpenAPI
88. اجرای تست امنیتی پایه (OWASP ZAP baseline) در CI
89. اجرای بار/استرس سبک روی endpoint پرترافیک
90. مستندسازی کامل API در docs/ و لینک به Swagger
91. تهیهٔ Postman/Bruno collection از OpenAPI
92. بازبینی نهایی امنیت endpointها و سرفصل‌های privacy
93. اجرای کامل تست‌های API — `dotnet test`
94. بازبینی نهایی Stage 5 و چک‌لیست DoD
95. ثبت رکورد پایان Stage 5 در readmehistory با تاریخ/زمان
96. افزودن endpoint /api/v1/meta (نسخه، ساعت سرور، وضعیت)
97. افزودن هدرهای RateLimit (Remaining/Reset) به پاسخ‌ها
98. افزودن endpoint توافق‌نامهٔ استفادهٔ API و سهمیه‌ها
99. افزودن صفحه‌بندی استاندارد (cursor/keyset) به همهٔ لیست‌ها
100. نوشتن تست بازگشت 304 Not Modified برای ETag

**Result 6 (معیار پایان):** همهٔ endpointها با Auth، Validation، Rate limit و OpenAPI کامل کار می‌کنند و تست عملکردی دارند.

---

## Part 7 — کلاینت وب (IPNote.ir) — UI/UX، تاریخچهٔ مرورگری و داشبورد (`S6`)

**هدف:** ساخت رابط وب واکنش‌گرا، دوزبانه و دارای تم تاریک/روشن که همهٔ امکانات را مصرف کند.

**تعداد زیربرنامه:** 100

1. قطعی‌سازی استک فرانت وب (Blazor یا SPA) و ثبت ADR
2. ساخت اسکلت پروژهٔ وب و اتصال به API
3. پیکربندی محیط‌ها (baseUrl API برای Dev/Prod)
4. راه‌اندازی سیستم طراحی بر اساس design-tokens مشترک
5. پیاده‌سازی تم تاریک/روشن با ذخیرهٔ ترجیح کاربر
6. پیاده‌سازی سوییچ زبان fa/en و جهت RTL/LTR
7. بارگذاری فونت فارسی و بهینه‌سازی آن
8. ساخت Layout اصلی واکنش‌گرا (موبایل/دسکتاپ)
9. ساخت Header/Nav/Footer با دسترس‌پذیری
10. ساخت صفحهٔ اصلی: نمایش بزرگ IPv4/IPv6
11. نمایش نوع IP و Local IP (از WebRTC)
12. دکمهٔ کپی IP و تولید QR
13. نمایش موقعیت روی نقشهٔ تعاملی
14. کارت اطلاعات ISP/ASN/شبکه
15. کارت اطلاعات دستگاه/مرورگر/OS
16. بخش دستورهای گرفتن IP (Linux/Mac/Win/PS/MikroTik) با تب و کپی
17. اسنیپت کد گرفتن IP در C#/JavaScript/Python/Bash
18. به‌روزرسانی زندهٔ IP هنگام تغییر شبکه
19. پیاده‌سازی تاریخچهٔ مرورگری با localStorage (بدون لاگین)
20. ساختار دادهٔ تاریخچهٔ محلی و نسخه‌بندی schema
21. نمایش لیست تاریخچهٔ محلی با زمان/موقعیت/دستگاه
22. حذف/پاک‌سازی تاریخچهٔ محلی توسط کاربر
23. همگام‌سازی/ادغام تاریخچهٔ محلی پس از لاگین
24. صفحهٔ ورود/ثبت‌نام (Email + OAuth)
25. جریان 2FA در ورود
26. مدیریت توکن/نشست در وب (Cookie یا توکن امن)
27. محافظت از مسیرهای داشبورد (route guard)
28. داشبورد: خط زمانی تاریخچهٔ IP کاربر
29. داشبورد: فیلتر/جستجو (تاریخ/کشور/دستگاه/تگ)
30. داشبورد: نقشهٔ تجمعی اتصال‌ها
31. داشبورد: آمار شخصی (یکتا/کشور/دستگاه)
32. داشبورد: یادداشت‌گذاری و تگ روی هر رکورد
33. داشبورد: مقایسهٔ دو اتصال (Diff)
34. داشبورد: خروجی CSV/JSON
35. داشبورد: مدیریت هشدارها (Alerts)
36. داشبورد: مدیریت ApiKeyها و مستندات API
37. صفحهٔ ابزارها: Ping با نمایش نتیجهٔ بلادرنگ
38. صفحهٔ ابزارها: Traceroute با نمایش hops روی نقشه
39. صفحهٔ ابزارها: Speed Test
40. صفحهٔ ابزارها: Subnet/CIDR calculator
41. صفحهٔ ابزارها: DNS lookup و WHOIS
42. صفحهٔ ابزارها: Port check و SSL inspect
43. صفحهٔ ابزارها: Blacklist/Reputation
44. صفحهٔ تست حریم خصوصی: WebRTC leak
45. صفحهٔ تست حریم خصوصی: DNS leak / IPv6 leak
46. بخش اثرانگشت مرورگر: Canvas/WebGL/Audio hash
47. بخش اثرانگشت: فونت‌ها/پلاگین‌ها/هدرها
48. نمایش درصد یکتایی و Privacy Score
49. ارسال اثرانگشت به API برای ذخیره/تحلیل
50. صفحهٔ پروفایل و تنظیمات حریم خصوصی
51. صفحهٔ حذف حساب و دانلود دادهٔ شخصی
52. ویجت/اسنیپت قابل‌جاسازی 'IP من' برای سایت‌های دیگر
53. اشتراک‌گذاری نتیجه (لینک/تصویر)
54. مدیریت حالت بارگذاری/خطا برای همهٔ فراخوانی‌ها
55. مدیریت خطای محلی‌شده و پیام کاربرپسند
56. بهینه‌سازی درخواست‌ها با کش سمت کلاینت
57. پیاده‌سازی PWA (manifest + service worker)
58. کارکرد آفلاین صفحات ایستا و دستورها
59. نصب‌پذیری PWA و آیکون‌ها
60. بهینه‌سازی Core Web Vitals (LCP/CLS/INP)
61. Lazy-load و code-splitting صفحات سنگین
62. بهینه‌سازی تصاویر/آیکون‌ها (SVG)
63. دسترس‌پذیری a11y (ARIA، کنتراست، کیبورد)
64. تست صفحه‌خوان و ناوبری کیبوردی
65. بررسی کامل‌بودن کلیدهای ترجمه fa/en صفحات
66. افزودن متادیتای سئو و Open Graph هر ابزار
67. ساخت sitemap.xml و robots.txt
68. صفحات محتوای آموزشی/وبلاگ (هر ابزار یک صفحه)
69. مدیریت بنر کوکی با گزینهٔ حریم‌محور (رد پیش‌فرض)
70. تست واکنش‌گرایی در بریک‌پوینت‌های موبایل/تبلت/دسکتاپ
71. تست تم تاریک/روشن در همهٔ صفحات
72. تست RTL کامل در فارسی (آیکون/جهت/چینش)
73. نوشتن تست واحد کامپوننت‌های کلیدی
74. نوشتن تست E2E (Playwright): مسیر IP→تاریخچه
75. نوشتن تست E2E: ورود→داشبورد→یادداشت
76. نوشتن تست E2E: ابزار ping/traceroute
77. نوشتن تست E2E: سوییچ زبان و تم
78. نوشتن تست دسترس‌پذیری خودکار (axe)
79. اندازه‌گیری Lighthouse و رفع موارد
80. افزودن آنالیتیکس حریم‌محور (بدون ردیابی تهاجمی)
81. افزودن مدیریت خطای سراسری و گزارش (Sentry اختیاری)
82. بهینه‌سازی bundle size و حذف وابستگی اضافی
83. بازبینی سازگاری با کد/الگوهای قبلی (قاعدهٔ ۱۵/۱۶)
84. بازبینی امنیت کلاینت (XSS، ذخیرهٔ امن توکن)
85. بررسی عدم نشت داده در URL/پارامتر
86. افزودن صفحهٔ 404/500 محلی‌شده
87. افزودن حالت skeleton/loading برای داشبورد
88. بهینه‌سازی صفحه‌بندی تاریخچهٔ بزرگ
89. افزودن تنظیم واحد نمایش (تاریخ شمسی/میلادی)
90. افزودن میانبر کپی همهٔ فیلدها
91. بازبینی UX جریان مهمان→کاربر (ادغام تاریخچه)
92. مستندسازی کامپوننت‌ها (Storybook اختیاری)
93. مستندسازی راهنمای کاربر (فارسی)
94. بازبینی نهایی طراحی توسط چک‌لیست UI/UX
95. اجرای کامل تست‌های وب در CI
96. بازبینی نهایی Stage 6 و چک‌لیست DoD
97. ثبت رکورد پایان Stage 6 در readmehistory با تاریخ/زمان
98. افزودن تنظیم نمایش IPv6 فشرده/کامل در UI
99. افزودن کپی نتایج به‌صورت curl-ready
100. افزودن میانبر کیبورد برای جستجوی سریع تاریخچه

**Result 7 (معیار پایان):** وب صفحهٔ اصلی IP، ابزارها، تاریخچهٔ localStorage و داشبورد کاربر را با کیفیت بالا ارائه می‌دهد.

---

## Part 8 — اپ Flutter (Android/iOS) — همهٔ امکانات با تجربهٔ بومی (`S7`)

**هدف:** ساخت اپ چندسکویی که همان APIها را مصرف کند و قابلیت‌های بومی موبایل را اضافه کند.

**تعداد زیربرنامه:** 100

1. ساخت پروژهٔ Flutter — `flutter create ntk_note_ip_app`
2. تعریف ساختار Clean Architecture (presentation/domain/data)
3. انتخاب مدیریت وضعیت (Riverpod پیشنهادی) و راه‌اندازی
4. راه‌اندازی DI با get_it/injectable
5. افزودن Dio و Interceptorها (auth/log/retry)
6. تولید مدل‌های Dart از openapi.json (code-gen)
7. ساخت لایهٔ data (repository + datasource remote/local)
8. ساخت لایهٔ domain (entities + usecases آینه‌ای با بک‌اند)
9. پیکربندی محیط‌ها (flavors: dev/prod) و baseUrl
10. راه‌اندازی تم Material 3 + سازگاری Cupertino
11. پیاده‌سازی تم تاریک/روشن سیستمی و دستی
12. راه‌اندازی l10n (intl) برای fa/en
13. پیاده‌سازی RTL کامل و فونت فارسی
14. ساخت ناوبری (go_router) و route guard داشبورد
15. صفحهٔ اصلی: نمایش IPv4/IPv6 و نوع
16. نمایش Local IP و اطلاعات شبکهٔ بومی
17. کپی IP و تولید/اسکن QR
18. نمایش موقعیت روی نقشه (flutter_map/google_maps)
19. کارت ISP/ASN/شبکه و دستگاه
20. بخش دستورهای گرفتن IP با کپی (همهٔ OSها + MikroTik)
21. ثبت مشاهدهٔ IP در API هنگام باز شدن اپ
22. ذخیرهٔ تاریخچهٔ محلی (Drift/Hive) برای آفلاین
23. همگام‌سازی تاریخچهٔ محلی با سرور
24. داشبورد: خط زمانی/فیلتر/جستجو
25. داشبورد: نقشهٔ تجمعی و آمار شخصی
26. داشبورد: یادداشت/تگ روی رکورد
27. داشبورد: مقایسهٔ دو اتصال
28. داشبورد: خروجی/اشتراک‌گذاری CSV/JSON
29. صفحهٔ ابزارها: Ping/Traceroute (نتیجهٔ بلادرنگ)
30. صفحهٔ ابزارها: Speed test/Subnet/Convert
31. صفحهٔ ابزارها: DNS/WHOIS/Port/SSL/Blacklist
32. تست نشت مرورگر پیش‌فرض دستگاه از طریق WebView
33. اطلاعات بومی دستگاه با device_info_plus
34. نوع/نام شبکه با connectivity_plus/network_info_plus
35. وضعیت باتری با battery_plus
36. ورود/ثبت‌نام (Email + OAuth) با جریان امن
37. ورود بیومتریک با local_auth
38. ذخیرهٔ امن توکن با flutter_secure_storage
39. جریان 2FA و کدهای بازیابی
40. مدیریت Refresh Token و خروج خودکار
41. صفحهٔ پروفایل/تنظیمات/حریم خصوصی
42. حذف حساب و دانلود دادهٔ شخصی
43. اعلان Push (FCM/APNs) برای تغییر IP/بلک‌لیست
44. مانیتورینگ تغییر IP در پس‌زمینه (workmanager)
45. ثبت خودکار رکورد هنگام اتصال به شبکهٔ جدید
46. ویجت صفحهٔ اصلی (home_widget) برای IP فعلی
47. پشتیبانی Deep Link/App Link (ipnote.ir → اپ)
48. اشتراک‌گذاری بومی (share_plus)
49. مدیریت حالت بارگذاری/خطا و retry
50. مدیریت خطای محلی‌شده و پیام کاربرپسند
51. حالت آفلاین و نمایش دادهٔ کش‌شده
52. مدیریت مجوزها (شبکه/اعلان/موقعیت) با توضیح شفاف
53. بهینه‌سازی عملکرد و جلوگیری از rebuild اضافی
54. بهینه‌سازی اندازهٔ اپ و دارایی‌ها
55. پشتیبانی صفحه‌بندی تاریخچهٔ بزرگ
56. افزودن تنظیم تاریخ شمسی/میلادی
57. افزودن حالت دسترس‌پذیری (اندازهٔ فونت/کنتراست)
58. نوشتن unit test برای usecaseها
59. نوشتن widget test برای صفحات کلیدی
60. نوشتن integration test مسیر IP→تاریخچه
61. نوشتن integration test ورود→داشبورد→یادداشت
62. تست RTL و سوییچ زبان
63. تست تم تاریک/روشن
64. تست رفتار آفلاین/آنلاین
65. تست اعلان و مانیتور پس‌زمینه
66. اجرای flutter analyze بدون خطا — `flutter analyze`
67. اجرای flutter test کامل — `flutter test`
68. پیکربندی آیکون و Splash اپ (flutter_launcher_icons)
69. پیکربندی نام/شناسهٔ بسته اندروید و iOS
70. پیکربندی امضای اندروید (keystore) — امن در CI
71. پیکربندی امضای iOS (provisioning/cert) — امن در CI
72. تنظیم ProGuard/R8 و حذف کد مرده
73. تنظیم ATS/Network security config (https اجباری)
74. بررسی عدم ذخیرهٔ داده حساس به‌صورت ناامن
75. بررسی obfuscation و نشت کلید — `flutter build apk --obfuscate --split-debug-info=...`
76. ساخت build اندروید (appbundle) — `flutter build appbundle`
77. ساخت build iOS — `flutter build ipa`
78. تهیهٔ متادیتا/اسکرین‌شات استور (fa/en)
79. تنظیم انتشار آزمایشی (Internal/TestFlight)
80. پیکربندی crash reporting (Crashlytics/Sentry)
81. پیکربندی آنالیتیکس حریم‌محور
82. بررسی کامل‌بودن کلیدهای ترجمهٔ اپ fa/en
83. بازبینی سازگاری مدل‌ها با تغییرات API (نسخه‌بندی)
84. بازبینی UX جریان مهمان→کاربر در اپ
85. بازبینی امنیت Deep Link (validation پارامتر)
86. بازبینی مصرف باتری مانیتور پس‌زمینه
87. تست روی چند اندازهٔ صفحه و نسخهٔ OS
88. تست روی دستگاه فیزیکی اندروید و iOS
89. بهینه‌سازی زمان شروع (cold start)
90. افزودن قابلیت نصب روی دسکتاپ/وب (اختیاری، همان کد پایه)
91. مستندسازی معماری اپ و راهنمای توسعه (فارسی)
92. مستندسازی راهنمای کاربر اپ
93. بازبینی نهایی طراحی اپ با چک‌لیست UI/UX
94. اجرای پایپ‌لاین build اپ در CI
95. بازبینی نهایی Stage 7 و چک‌لیست DoD
96. ثبت ADR انتخاب Riverpod/معماری اپ
97. ثبت رکورد پایان Stage 7 در readmehistory با تاریخ/زمان
98. افزودن pull-to-refresh در صفحهٔ اصلی
99. افزودن haptic feedback روی اکشن‌های کلیدی
100. افزودن درخواست محترمانهٔ امتیازدهی درون‌برنامه (in-app review)

**Result 8 (معیار پایان):** اپ با همهٔ امکانات، تم/زبان، تاریخچه، داشبورد، اعلان تغییر IP و ورود بیومتریک منتشرشدنی است.

---

## Part 9 — تست، کیفیت، امنیت و حریم خصوصی (سرتاسری) (`S8`)

**هدف:** تضمین کیفیت، پایداری و امنیت کل سیستم پیش از انتشار، و رعایت حریم خصوصی.

**تعداد زیربرنامه:** 100

1. تعریف استراتژی تست سرتاسری (هرم تست) و معیار پوشش
2. اندازه‌گیری پوشش تست بک‌اند و گزارش (coverlet)
3. افزودن دروازهٔ پوشش حداقلی در CI
4. تست واحد لایهٔ Domain (مرور کامل)
5. تست واحد لایهٔ Application (Handlerها/Validatorها)
6. تست یکپارچهٔ Infrastructure با Testcontainers
7. تست عملکردی API (WebApplicationFactory)
8. تست قرارداد API مطابق OpenAPI (مصرف‌کننده/تولیدکننده)
9. تست E2E وب (Playwright) مسیرهای حیاتی
10. تست integration اپ Flutter مسیرهای حیاتی
11. تست رگرسیون برای باگ‌های بستهٔ قبلی
12. تست داده‌های مرزی IP (v4/v6/CGNAT/reserved)
13. تست محلی‌سازی (fa/en) و کامل‌بودن کلیدها
14. تست RTL/LTR در وب و اپ
15. تست تم تاریک/روشن در وب و اپ
16. تست واکنش‌گرایی در بریک‌پوینت‌های مختلف
17. تست بار (load) روی endpointهای پرترافیک (k6)
18. تست استرس و یافتن نقطهٔ شکست
19. تست پایداری بلندمدت (soak test)
20. تست رفتار در قطعی Providerهای بیرونی (chaos سبک)
21. تست fallback آفلاین MMDB
22. تست Rate Limiting و سهمیه‌ها
23. تست نشت حافظه/اتصال در سرور
24. پروفایل کارایی و رفع گلوگاه‌های CPU/IO
25. بهینه‌سازی کوئری‌های کند (EF logging/analyze)
26. اجرای SAST (CodeQL) و رفع یافته‌ها
27. اجرای DAST (OWASP ZAP) روی محیط staging
28. اسکن وابستگی‌ها (NuGet/npm/pub audit) و رفع آسیب‌پذیری
29. اسکن اسرار در مخزن (gitleaks)
30. بازبینی OWASP Top 10 (Injection/Auth/XSS/...)
31. بازبینی امنیت JWT (الگوریتم/انقضا/چرخش)
32. بازبینی امنیت Cookie (HttpOnly/Secure/SameSite)
33. بازبینی CORS و عدم wildcard خطرناک
34. بازبینی هدرهای امنیتی (HSTS/CSP/XFO)
35. بازبینی Rate Limit ضد brute-force روی login
36. افزودن قفل حساب/تاخیر پس از تلاش ناموفق
37. بازبینی ذخیرهٔ امن رمز (hash) و ApiKey
38. بازبینی محافظت CSRF در فرم‌های وب
39. بازبینی اعتبارسنجی ورودی همهٔ endpointها
40. بازبینی مدیریت خطا بدون افشای جزئیات حساس
41. بازبینی ماسک‌کردن PII در لاگ‌ها
42. تعریف و اجرای سیاست data retention تاریخچه
43. پیاده‌سازی anonymize/حذف خودکار دادهٔ قدیمی
44. بازبینی رضایت کاربر برای ذخیرهٔ تاریخچه
45. پیاده‌سازی export/delete کامل دادهٔ شخصی (GDPR)
46. بازبینی سیاست کوکی و بنر حریم‌محور
47. بازبینی عدم ارسال PII به سرویس‌های ثالث بدون رضایت
48. بازبینی رمزنگاری داده در حال انتقال (TLS) و در حال سکون
49. تهیهٔ سند تهدیدمدل (threat model) ساده
50. تهیهٔ سند پاسخ به حادثه (incident response)
51. تست بازیابی از بکاپ دیتابیس
52. تست مهاجرت بدون توقف روی کپی Prod
53. تست سازگاری نسخهٔ API با اپ‌های قدیمی
54. تست deep link و مسیرهای ورود اپ
55. تست اعلان‌ها و مانیتور پس‌زمینهٔ اپ
56. تست دسترس‌پذیری خودکار (axe) و دستی
57. تست با صفحه‌خوان و ناوبری کیبوردی
58. تست کنتراست رنگ در هر دو تم
59. تست سازگاری مرورگرها (Chrome/Firefox/Safari/Edge)
60. تست روی نسخه‌های مختلف اندروید/iOS
61. بازبینی Core Web Vitals و بودجهٔ کارایی
62. بازبینی اندازهٔ bundle وب و اپ
63. تست رفتار شبکهٔ ضعیف/قطع‌ووصل
64. تست همگام‌سازی تاریخچهٔ مهمان→کاربر بدون از دست رفتن داده
65. تست تکراری‌نشدن رکورد در ثبت مشاهده
66. تست صحت محاسبات Subnet/Convert با موارد مرجع
67. تست صحت تشخیص VPN/Proxy/Tor با نمونه‌ها
68. تست صحت Blacklist با IPهای معلوم
69. تست صحت Geo/ASN در مقابل منبع مرجع
70. بازبینی پیام‌های خطای محلی‌شده برای کاربر
71. بازبینی کیفیت کد (SonarQube/سنجه‌ها) و رفع code smell
72. بازبینی پوشش مستندات کد (XML-doc/dartdoc)
73. بازبینی انطباق با کنوانسیون‌های پروژه (قاعدهٔ ۱۲/۲۸)
74. بازبینی سازگاری تغییرات با کد قبلی (قاعدهٔ ۱۶)
75. اجرای کامل مجموعهٔ تست در CI (سبز)
76. تثبیت تست‌های flaky و حذف ناپایداری
77. تهیهٔ گزارش کیفیت نهایی فاز
78. بازبینی چک‌لیست امنیت پیش از انتشار
79. بازبینی چک‌لیست حریم خصوصی پیش از انتشار
80. تهیهٔ release notes فنی (fa)
81. بازبینی نهایی Stage 8 و چک‌لیست DoD
82. اجرای تست نفوذ سبک (در صورت امکان) و رفع موارد
83. بازبینی لاگ‌ها برای داده‌های ناخواسته
84. بازبینی متریک‌ها و آستانهٔ هشدار
85. بازبینی دسترسی‌ها و اصل حداقل امتیاز
86. بازبینی پیکربندی Prod (عدم افشای Swagger حساس)
87. بازبینی خطاهای 4xx/5xx و نرخ آن‌ها
88. بازبینی سناریوهای حقوقی/سوءاستفاده (port scan/abuse)
89. افزودن محدودیت/شرایط استفاده برای ابزارهای حساس
90. بازبینی سازگاری GDPR/مقررات محلی
91. تهیهٔ سند privacy policy و terms (fa/en)
92. بازبینی نهایی پیش از Go/No-Go
93. ثبت تصمیم Go/No-Go و مسئولان
94. آرشیو نتایج تست و گزارش‌ها در docs/
95. ثبت رکورد پایان Stage 8 در readmehistory با تاریخ/زمان
96. تست pseudo-localization برای کشف رشته‌های هاردکدشده
97. تست سازگاری نمایش تاریخ شمسی/میلادی
98. تست رفتار سیستم در منطقه‌های زمانی مختلف
99. تست export حجیم تاریخچه (۱۰٬۰۰۰ رکورد)
100. بازبینی و حداقل‌سازی مجوزهای درخواستی اپ

**Result 9 (معیار پایان):** پوشش تست هدف، بدون آسیب‌پذیری شناخته‌شدهٔ مهم، و انطباق حریم خصوصی محقق شده است.

---

## Part 10 — DevOps، CI/CD، استقرار، پایش و مستندسازی نهایی (`S9`)

**هدف:** خودکارسازی ساخت/تست/استقرار، راه‌اندازی محیط Prod، پایش و انتشار رسمی محصول.

**تعداد زیربرنامه:** 100

1. تثبیت workflow CI نهایی (build/test/analyze/coverage)
2. افزودن مرحلهٔ امنیتی (CodeQL/gitleaks/dep-audit) به CI
3. افزودن ساخت آرتیفکت بک‌اند (publish) در CI — `dotnet publish -c Release`
4. ساخت Dockerfile چندمرحله‌ای برای Api
5. بهینه‌سازی image (distroless/trim) و اندازهٔ آن
6. اسکن آسیب‌پذیری image (Trivy)
7. انتشار image به Registry با تگ نسخه
8. ساخت Dockerfile/asset برای کلاینت وب
9. تنظیم build اپ Flutter در CI (apk/aab/ipa)
10. تنظیم انتشار اپ به Play/TestFlight (fastlane)
11. تعریف محیط‌های Staging و Production
12. تعریف استراتژی استقرار (Blue-Green/Canary)
13. نوشتن Helm chart یا manifest (Kubernetes) — اگر k8s
14. یا تعریف docker-compose Prod — اگر تک‌سرور
15. تنظیم Reverse Proxy (Nginx/Traefik/Caddy) با TLS
16. صدور گواهی TLS (Let's Encrypt) و تمدید خودکار
17. پیکربندی دامنهٔ IPNote.ir و رکوردهای DNS
18. پیکربندی CDN و کش لبه برای دارایی‌های وب
19. پیکربندی صحیح ForwardedHeaders پشت CDN/Proxy
20. تنظیم متغیرهای محیطی و Secrets در Prod (Vault/KeyVault)
21. اجرای Migration به‌صورت idempotent در استقرار — `dotnet ef migrations script -i`
22. تنظیم سیاست rollback استقرار
23. تنظیم health probe و readiness در ارکستراتور
24. تنظیم autoscaling (HPA) بر اساس بار — اگر k8s
25. تنظیم محدودیت منابع (CPU/Memory) سرویس‌ها
26. راه‌اندازی Redis و DB مدیریت‌شده در Prod
27. تنظیم بکاپ خودکار DB و تست بازیابی دوره‌ای
28. تنظیم نگه‌داری/چرخش لاگ‌ها
29. راه‌اندازی پایش (Prometheus/Grafana) و داشبوردها
30. راه‌اندازی Tracing (OpenTelemetry→Jaeger/Tempo)
31. راه‌اندازی Log aggregation (Seq/Loki)
32. تعریف هشدارها (Alertmanager) برای خطا/تاخیر/منابع
33. تعریف SLO/SLI و بودجهٔ خطا
34. راه‌اندازی Uptime monitoring بیرونی
35. راه‌اندازی crash/error reporting (Sentry) برای وب و اپ
36. تنظیم پایپ‌لاین CD با تأیید دستی برای Prod
37. تنظیم انتشار خودکار وب پس از سبزشدن تست
38. تنظیم نسخه‌بندی و تگ Git خودکار
39. به‌روزرسانی خودکار CHANGELOG از Conventional Commits
40. تنظیم feature flags برای انتشار تدریجی
41. اجرای smoke test پس از هر استقرار
42. اجرای تست دود اپ روی نسخهٔ منتشرشده
43. تنظیم زمان‌بندی Jobها در Prod (پایش IP/به‌روزرسانی MMDB)
44. بررسی هزینه/سهمیهٔ APIهای بیرونی در مقیاس
45. تنظیم rate limit و WAF در لبه
46. تنظیم محافظت DDoS پایه
47. تنظیم سیاست CORS/CSP نهایی Prod
48. بررسی انطباق دامنه با ATS اپ iOS
49. تنظیم deep link verification (assetlinks/apple-app-site-association)
50. تهیهٔ صفحهٔ وضعیت (status page)
51. تهیهٔ runbook عملیاتی (راه‌اندازی/توقف/rollback)
52. تهیهٔ سند on-call و escalation
53. تهیهٔ سند معماری نهایی (C4 کامل) در docs/
54. تهیهٔ مستندات API عمومی برای توسعه‌دهندگان
55. انتشار صفحهٔ مستندات API و نمونه‌کدها (C#/JS)
56. تهیهٔ راهنمای شروع‌سریع توسعه‌دهنده
57. تهیهٔ راهنمای کاربر وب و اپ (fa)
58. تهیهٔ ویدئو/اسکرین‌شات معرفی محصول
59. بهینه‌سازی سئو نهایی و ثبت در Search Console
60. ثبت sitemap و بررسی ایندکس‌شدن
61. بررسی Core Web Vitals در محیط Prod
62. اجرای تست بار روی Prod-like پیش از انتشار
63. برنامهٔ انتشار (release plan) و بازهٔ زمانی
64. اجرای انتشار نسخهٔ MVP وب
65. اجرای انتشار نسخهٔ MVP اپ (بتا)
66. جمع‌آوری بازخورد اولیه و ثبت در بک‌لاگ
67. پایش متریک‌های پس از انتشار و رفع فوری اشکال
68. بازبینی امنیت پس از انتشار (post-launch review)
69. بازبینی هزینهٔ زیرساخت و بهینه‌سازی
70. برنامهٔ نگه‌داری و به‌روزرسانی وابستگی‌ها
71. برنامهٔ افزودن امکانات v1/Future از کاتالوگ
72. تنظیم چرخهٔ بازبینی plan files و readmehistory
73. بازبینی کامل‌بودن ترجمه‌ها پس از تغییرات نهایی
74. بازبینی انطباق نهایی با همهٔ کنوانسیون‌های پروژه
75. آرشیو نسخه و آرتیفکت‌های انتشار
76. تهیهٔ گزارش پایان پروژه (فاز فعلی)
77. به‌روزرسانی Cursor.XX.plan.md بعدی برای فاز توسعهٔ مستمر
78. بررسی نهایی dashboardهای پایش و آستانه‌ها
79. بررسی نهایی بکاپ/بازیابی و DR
80. بررسی نهایی گواهی‌ها و تمدید خودکار
81. بررسی نهایی deep link/OAuth callback در Prod
82. بررسی نهایی محدودیت‌ها و شرایط استفادهٔ ابزارها
83. بررسی نهایی صفحات حقوقی (privacy/terms)
84. بررسی نهایی آنالیتیکس حریم‌محور
85. بررسی نهایی crash-free rate اپ
86. بررسی نهایی نرخ خطای API
87. بررسی نهایی زمان پاسخ p95/p99
88. بررسی نهایی ظرفیت و مقیاس‌پذیری
89. تأیید Go-Live رسمی توسط ذی‌نفعان
90. اعلام عمومی انتشار IPNote.ir
91. پشتیبانی پس از انتشار و حلقهٔ بازخورد
92. مستندسازی درس‌آموخته‌ها (retrospective)
93. بازبینی نهایی Stage 9 و چک‌لیست DoD
94. ثبت رکورد پایان Stage 9 و انتشار در readmehistory با تاریخ/زمان
95. هم‌سان‌سازی کامل محیط Staging با Prod (environment parity)
96. افزودن smoke-test خودکار deep link پس از هر استقرار
97. تعریف بودجهٔ هزینهٔ ماهانه و هشدار مصرف زیرساخت
98. تنظیم چرخش خودکار Secrets و کلیدها
99. برنامه‌ریزی DR drill دوره‌ای (تمرین بازیابی فاجعه)
100. افزودن صفحهٔ Changelog عمومی برای کاربران

**Result 10 (معیار پایان):** خط لولهٔ کامل CI/CD، استقرار پایدار Prod با پایش و بکاپ، و مستندات و انتشار اپ/وب آماده است.

---

## readmehistory

- **2026-05-29 07:48 UTC** — تولید پلن نهایی `IPNote.plan.md` + `IPNote.plan.prompt.json` با 10 مرحله و 1000 زیربرنامه (حداقل ۱۰۰ در هر مرحله). معماری API-First برای وب + Flutter. سورس روی درایو محلی است؛ تطبیق با کد واقعی در Part 1 (S0) لحاظ شده. هیچ کدی نوشته نشد.