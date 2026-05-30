# Cursor Plan — Ntk.Note.IP (Admin roles & permissions)

```json
{
  "metadata": {
    "project": "IPNote.ir",
    "part": "Part 74",
    "updatedAt": "2026-05-30T09:00:00+03:30",
    "previousPart": "Cursor.73.plan.md"
  },
  "Part 74": {
    "title": "Admin dashboard roles and permission settings",
    "goal": "Section in admin dashboard + dedicated page to configure roles and their access permissions",
    "backend": [
      "Permissions.cs + role claims via AspNetRoleClaims",
      "IAdminRoleService / AdminRoleService",
      "AdminRoles endpoints: GetList, GetListPermissions, Add, UpdatePermissions, Delete",
      "Seed Administrator with all permissions"
    ],
    "frontend": [
      "Angular /admin/roles permission matrix",
      "Admin dashboard roles summary card",
      "Flutter admin Roles tab",
      "i18n fa/en (+ ar/fr mobile)"
    ]
  },
  "Result 74": {
    "summary": "Admin can view roles on dashboard, open /admin/roles to toggle permission checkboxes per role, add/delete custom roles. Backend stores permissions as Identity role claims. Infrastructure build OK.",
    "routes": ["/admin/dashboard", "/admin/roles"]
  }
}
```
