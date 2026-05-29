# IPNote.plan — وضعیت پیاده‌سازی (ممیزی)

**مرجع:** `plan.prompt/IPNote.plan.md` — ۱۰ Stage، ۱۰۰۰ زیربرنامه  
**تاریخ ممیزی:** 2026-05-31  
**نتیجه کلی:** هستهٔ MVP وب + API + موبایل + DevOps **تحویل شده**؛ بخش بزرگی از ۱۰۰۰ آیتم آیتم‌به‌آیتم بسته نشده (عمدی: Future / Go-Live / زیرساخت تیم).

## خلاصهٔ Stageها

| Stage | عنوان | وضعیت | شواهد |
|-------|--------|--------|--------|
| **S0** | محیط و کنوانسیون | **Partial** | `build.ps1`, CI, `.editorconfig`, `readmehistory`, ADRها؛ devcontainer/Makefile کامل نیست |
| **S1** | اسکلت Clean Architecture | **Done** | Domain/Application/Infrastructure/Web، ArchUnit، MediatR |
| **S2** | Domain IP | **Partial** | IpNote, IpLookupRecord, IpRecord؛ همهٔ ۵۰ VO کاتالوگ نیست |
| **S3** | Application CQRS | **Done (MVP)** | IpLookup, IpNotes, Auth Identity؛ پوشش امکانات اصلی |
| **S4** | Infrastructure | **Done (MVP)** | EF, Fake/Real providers, Hangfire, Outbox, Redis opt |
| **S5** | API | **Done (MVP)** | Minimal API groups, JWT, Rate limit, OpenAPI |
| **S6** | وب Angular | **Done (MVP)** | IP lookup, dashboard, notes, i18n, theme |
| **S7** | Flutter | **Done (MVP)** | Parts 47–60؛ [s7-stage-close-checklist.md](mobile/s7-stage-close-checklist.md) |
| **S8** | تست و امنیت | **Done (core)** | Coverage gate, E2E, security headers, baseline |
| **S9** | DevOps | **Done (core)** | [s9-stage-close-checklist.md](devops/s9-stage-close-checklist.md) Parts 38–46 |

## Post-S9 (Parts 47–61)

| Part | موضوع | وضعیت |
|------|--------|--------|
| 47–48 | PostgreSQL, hardening | Done |
| 49–50 | Deep links web + Flutter | Done (Go-Live placeholders) |
| 51 | run-all | Done |
| 52–57 | OpenAPI, Drift, biometric, background, retrofit, review | Done |
| 58 | Refresh token | Done |
| 59 | Store release tooling | Done |
| 60 | IPushSender + flutter-release CI | Done (foundation) |
| **61** | Gap fill: UpdateIpNote UI, PushDevice API, این ممیزی | Done |
| **62** | Flutter FCM register/unregister + Firebase deps | Done (placeholder config) |
| **63** | Server IP monitor + push send + Flutter hook | Done (NoOp default; Firebase opt-in) |
| **64** | Hangfire FCM poll + Flutter `monitor_ip` handler | Done |

## انجام‌شده در Part 64

1. **Hangfire:** `push-ip-monitor-poll` — data push `monitor_ip` when snapshot older than `IpMonitorPollIntervalMinutes`
2. **Flutter:** `PushIpMonitorListener` → `ActionMonitorMyIp`; push register on login
3. **Tests:** **40/40** functional

## انجام‌شده در Part 63

1. **Backend:** `UserPublicIpSnapshot` + migration; `POST /api/v1/IpLookup/ActionMonitorMyIp`; push on change via `UserPushNotificationService` + `FirebasePushSender`
2. **Flutter:** `ActionMonitorMyIpUseCase`; fire-and-forget on dashboard load when signed in
3. **Tests:** `ActionMonitorMyIpTests` + resolver TearDown; **38/38** functional

## انجام‌شده در Part 61 (این دستور)

1. **Flutter:** ویرایش یادداشت IP (`UpdateIpNote`) — UI + use case  
2. **Backend:** `PushDeviceRegistration` + `ActionRegister` / `ActionUnregister`  
3. **این سند:** ممیزی صادقانهٔ plan در برابر کد

## معوق (نیاز به پروژه Firebase / Go-Live / تیم)

| موضوع | Plan ref | یادداشت |
|--------|----------|---------|
| FCM/APNs کامل | S7-043, S4 push | Flutter ثبت توکن + سرور `FirebasePushSender` + `ActionMonitorMyIp`؛ پیش‌فرض NoOp تا credentials |
| OAuth / 2FA | S7-036–039 | فقط Email login |
| Ping/Traceroute/Speed در اپ | S7-029–031 | ابزار compare هست؛ API ping در بک‌اند محدود |
| fastlane | S9-010 | معوق |
| TEAMID / SHA256 | S9-049 | اسکریپت `update-deep-links.ps1` |
| Prometheus/Grafana prod | S9 | compose نمونه |
| Sentry/ZAP | S8/S9 | معوق |
| ۱۴۷ امکان کاتالوگ کامل | S0-087 | MVP اولویت‌دار شده |

## Go-Live (دستی)

- [ ] Secrets استقرار Production  
- [ ] `update-deep-links.ps1` + `-StrictDeepLinks`  
- [ ] انتشار Play / TestFlight  
- [ ] تأیید ذی‌نفع (S9-089)

## دستورات تأیید

```powershell
.\build.ps1
.\scripts\flutter-ci.ps1
.\scripts\verify-deep-links-placeholders.ps1
```

## Related

- `Cursor.1.plan.md` … `Cursor.64.plan.md`
- `plan.prompt/IPNote.plan.md`
