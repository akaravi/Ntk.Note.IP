# Cursor Plan — Ntk.Note.IP (admin panel)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 70",
    "updatedAt": "2026-05-29T20:30:00+03:30",
    "previousPart": "Cursor.69.plan.md"
  },
  "Part 70": {
    "title": "Full admin panel (backend + Angular)",
    "goal": "Administrator-only APIs and /admin SPA for users, notes, lookups, push devices, outbox; fix IpLookup list scoping for non-admins",
    "backend": {
      "policy": "Policies.RequireAdministrator",
      "endpointGroups": [
        "AdminDashboard",
        "AdminAccess",
        "AdminUsers",
        "AdminIpNotes",
        "AdminIpLookupRecords",
        "AdminPushDevices",
        "AdminOutbox"
      ],
      "seedAdmin": "administrator@localhost / Administrator1!"
    },
    "frontend": {
      "route": "/admin",
      "guard": "AuthGuard + AdminGuard",
      "sections": ["dashboard", "users", "ip-notes", "ip-lookups", "push", "outbox"]
    }
  },
  "Result 70": {
    "summary": "Admin MediatR handlers + minimal API groups; Angular admin shell with theme tokens; AdminAccess for nav/guard; GetListIpLookupRecords scoped by CreatedBy for non-admin; functional tests AdminApiTests; i18n ADMIN.* fa/en.",
    "urls": {
      "adminPanel": "/admin",
      "adminAccessApi": "/api/v1/AdminAccess/GetOne",
      "adminDashboardApi": "/api/v1/AdminDashboard/GetOne"
    }
  }
}
```
