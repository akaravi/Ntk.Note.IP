import { Component, OnInit, computed, inject, signal } from '@angular/core';
import {
  AdminPermissionCatalogItemDto,
  AdminRoleDto,
  AdminService,
} from './admin.service';
import { I18nService } from '../core/i18n.service';

@Component({
  standalone: false,
  selector: 'app-admin-roles',
  templateUrl: './admin-roles.component.html',
  styleUrls: ['./admin-roles.component.scss'],
})
export class AdminRolesComponent implements OnInit {
  private readonly admin = inject(AdminService);
  readonly i18n = inject(I18nService);

  loading = signal(true);
  saving = signal(false);
  error = signal<string | null>(null);
  roles = signal<AdminRoleDto[]>([]);
  catalog = signal<AdminPermissionCatalogItemDto[]>([]);
  selectedRoleId = signal<string | null>(null);
  permissionDraft = signal<string[]>([]);
  showCreate = signal(false);
  newRoleName = '';

  selectedRole = computed(() =>
    this.roles().find((role) => role.id === this.selectedRoleId()) ?? null
  );

  permissionGroups = computed(() => {
    const groups = new Map<string, AdminPermissionCatalogItemDto[]>();
    for (const item of this.catalog()) {
      const bucket = groups.get(item.groupKey) ?? [];
      bucket.push(item);
      groups.set(item.groupKey, bucket);
    }
    return [...groups.entries()].map(([groupKey, items]) => ({ groupKey, items }));
  });

  ngOnInit(): void {
    this.load();
  }

  load(): void {
    this.loading.set(true);
    this.error.set(null);

    this.admin.getRoles().subscribe({
      next: (roles) => {
        this.roles.set(roles);
        this.loading.set(false);
        const current = this.selectedRoleId();
        const nextSelection = roles.find((role) => role.id === current) ?? roles[0] ?? null;
        this.selectRole(nextSelection);
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.loading.set(false);
      },
    });

    this.admin.getPermissionCatalog().subscribe({
      next: (items) => this.catalog.set(items),
      error: (err: Error) => this.error.set(err.message),
    });
  }

  selectRole(role: AdminRoleDto | null): void {
    if (!role) {
      this.selectedRoleId.set(null);
      this.permissionDraft.set([]);
      return;
    }

    this.selectedRoleId.set(role.id);
    this.permissionDraft.set([...role.permissions]);
  }

  isPermissionChecked(key: string): boolean {
    return this.permissionDraft().includes(key);
  }

  togglePermission(key: string, checked: boolean): void {
    const current = new Set(this.permissionDraft());
    if (checked) {
      current.add(key);
    } else {
      current.delete(key);
    }
    this.permissionDraft.set([...current].sort());
  }

  savePermissions(): void {
    const role = this.selectedRole();
    if (!role) {
      return;
    }

    this.saving.set(true);
    this.error.set(null);
    this.admin.updateRolePermissions(role.id, this.permissionDraft()).subscribe({
      next: () => {
        this.saving.set(false);
        this.load();
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.saving.set(false);
      },
    });
  }

  openCreate(): void {
    this.newRoleName = '';
    this.permissionDraft.set([]);
    this.showCreate.set(true);
  }

  cancelCreate(): void {
    this.showCreate.set(false);
    const role = this.selectedRole();
    if (role) {
      this.permissionDraft.set([...role.permissions]);
    }
  }

  createRole(): void {
    const name = this.newRoleName.trim();
    if (!name) {
      this.error.set(this.i18n.t('ADMIN.ROLES.NAME_REQUIRED'));
      return;
    }

    this.saving.set(true);
    this.error.set(null);
    this.admin.addRole(name, this.permissionDraft()).subscribe({
      next: () => {
        this.saving.set(false);
        this.showCreate.set(false);
        this.load();
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.saving.set(false);
      },
    });
  }

  deleteRole(role: AdminRoleDto): void {
    if (role.isSystem) {
      return;
    }

    const confirmed = window.confirm(this.i18n.t('ADMIN.ROLES.CONFIRM_DELETE'));
    if (!confirmed) {
      return;
    }

    this.saving.set(true);
    this.error.set(null);
    this.admin.deleteRole(role.id).subscribe({
      next: () => {
        this.saving.set(false);
        this.load();
      },
      error: (err: Error) => {
        this.error.set(err.message);
        this.saving.set(false);
      },
    });
  }

  permissionLabel(key: string): string {
    const normalized = key.replace(/\./g, '_').toUpperCase();
    return this.i18n.t(`ADMIN.PERMS.${normalized}`);
  }
}
