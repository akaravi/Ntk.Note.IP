# IPNote.ir — معرفی پروژه

**IPNote.ir** پلتفرم یادداشت و مدیریت اطلاعات IP است؛ یک بک‌اند مشترک (.NET 10 + Clean Architecture) برای وب (Angular) و اپ موبایل (Flutter).

## پیش‌نیازها

- .NET 10 SDK
- Node.js LTS (برای Angular)
- Flutter SDK stable (اپ موبایل — `src/Mobile/ntk_note_ip_app`)

## اجرای سریع

```powershell
dotnet run --project src\AppHost\AppHost.csproj --launch-profile https
```

یا:

```powershell
.\build.ps1
```

## ساختار

| پوشه | توضیح |
|------|--------|
| `src/Domain` | موجودیت‌ها و قواعد دامنه |
| `src/Application` | CQRS، اعتبارسنجی |
| `src/Infrastructure` | EF Core، Identity |
| `src/Web` | API + Angular |
| `src/Mobile/ntk_note_ip_app` | Flutter (Android/iOS/Windows) |
| `src/AppHost` | Aspire |
| `docs/` | معماری، ADR، i18n |
| `plan.prompt/` | پلن اجرایی ۱۰ مرحله‌ای |

## Flutter (موبایل)

```powershell
.\scripts\flutter-ci.ps1
cd src\Mobile\ntk_note_ip_app
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5340
```

[راهنمای اجرا](docs/runbooks/flutter-mobile.md)

## تأیید کامل (build + تست + سلامت)

```powershell
.\scripts\run-verify-all.ps1
```

[راهنمای استک محلی](docs/runbooks/local-dev-stack.md)

## پوشش تست و بار

```powershell
.\scripts\coverage.ps1
.\scripts\run-e2e.ps1
.\scripts\run-k6-smoke.ps1   # نیاز به نصب k6
```

[راهنمای بار k6](docs/runbooks/load-testing.md)

[استراتژی تست و DoD](docs/testing/testing-strategy.md) — آستانه پوشش خطی **۴۰٪** در CI.

[خط پایه امنیت](docs/security/security-baseline.md) — Rate limit، هدرها، `.\scripts\security-audit.ps1`

[استقرار Production](docs/runbooks/production-deploy.md) — Docker، `docker compose -f docker-compose.prod.yml`، migration، Trivy

## مستندات

- [معماری](docs/architecture/ipnote-overview.md)
- [پلن اجرایی](plan.prompt/IPNote.plan.prompt.json)
- [تاریخچه تغییرات](readmehistory.md)

## زبان پایه

فارسی (`docs/i18n/fa.json`) — انگلیسی هم‌تراز در `docs/i18n/en.json`.

بررسی کلیدها:

```powershell
.\scripts\check-i18n-keys.ps1
```
