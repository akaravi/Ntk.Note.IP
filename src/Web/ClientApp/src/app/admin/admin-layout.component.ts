import { Component, inject } from '@angular/core';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-layout',
  templateUrl: './admin-layout.component.html',
  styleUrls: ['./admin-layout.component.scss'],
})
export class AdminLayoutComponent {
  readonly i18n = inject(I18nService);

  readonly navItems = [
    { path: 'dashboard', key: 'ADMIN.NAV.DASHBOARD' },
    { path: 'roles', key: 'ADMIN.NAV.ROLES' },
    { path: 'users', key: 'ADMIN.NAV.USERS' },
    { path: 'ip-notes', key: 'ADMIN.NAV.IP_NOTES' },
    { path: 'ip-lookups', key: 'ADMIN.NAV.IP_LOOKUPS' },
    { path: 'push', key: 'ADMIN.NAV.PUSH' },
    { path: 'outbox', key: 'ADMIN.NAV.OUTBOX' },
    { path: 'tickets', key: 'ADMIN.NAV.TICKETS' },
  ];
}
